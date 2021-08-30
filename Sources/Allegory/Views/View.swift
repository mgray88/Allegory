//
// Created by Mike on 7/29/21.
//

import RxSwift
import UIKit

/// A type that represents part of your app’s user interface and provides
/// modifiers that you use to configure views.
///
/// You create custom views by declaring types that conform to the `View`
/// protocol. Implement the required ``body`` computed property to provide the
/// content for your custom view.
/// ```swift
/// struct MyView: View {
///     var body: SomeView {
///         Text("Hello, World!")
///     }
/// }
/// ```
public protocol View: SomeView {
    associatedtype Body: View
    @ViewBuilder
    var body: Body { get }
}

extension View {
    @ViewBuilder
    public var body: SomeView {
        (body as Body)
    }
}

extension View where Body == Never {
    public var body: Never {
        fatalError()
    }
}

extension View {
    func buildNodeTree() {}
}

/// A `View` that offers primitive functionality, which renders its `body`
/// inaccessible.
protocol _PrimitiveView: SomeView {
    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize
    func render(in container: Container, bounds: Bounds, pass: LayoutPass)
    func buildNodeTree(_ node: Node)
}

class ViewNode: UIKitNode {

    var hierarchyIdentifier: String {
        "View<\(node.hierarchyIdentifier)>"
    }

    var node: SomeUIKitNode!

    var view: SomeView!
    var context: Context!

    var propertyStorage: [String: Any] = [:]
    var disposeBag = DisposeBag()
    var needsRebuild = false

    func update(view: SomeView, context: Context) {
        self.view = view
        self.context = context
        ViewNode.configureEnvironmentObjectProperties(of: view, context: context)
        node = view.body.resolve(context: context, cachedNode: node ?? nil)
        observeStateProperties(of: view)
    }

    func update(view: Never, context: Context) {
    }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        node.size(fitting: proposedSize, pass: pass)
    }

    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        node.render(in: container, bounds: bounds, pass: pass)
    }

    func rebuildIfNeeded() {
        if needsRebuild {
            needsRebuild = false
            update(view: view, context: context)
            context.renderer?.setNeedsRendering()
        }
    }

    private func observeStateProperties(of view: SomeView) {
        disposeBag = DisposeBag()
        let mirror = Mirror(reflecting: view)
        for (label, value) in mirror.children where label != nil {
            if let property = value as? StateProperty {
                if propertyStorage[label!] == nil { propertyStorage[label!] = property.storage.initialValue }
                property.storage.get = { [unowned self] in self.propertyStorage[label!]! }
                property.storage.set = { [unowned self] in
                    self.propertyStorage[label!] = $0
                    self.contentWillChange()
                }
            } else if var property = value as? EnvironmentObjectProperty {
                let key = property.storage.objectTypeIdentifier
                property.storage.get = { [unowned self] in self.context.environmentObjects[key]! }
                property.storage.set = { [unowned self] in self.context.environmentObjects[key] = $0 }
            } else if let property = value as? ObservedProperty {
                property.objectWillChange
                    .subscribe(onNext: { [weak self] in
                        self?.contentWillChange()
                    })
                    .disposed(by: disposeBag)
            }
        }
    }

    private func contentWillChange() {
        DispatchQueue.main.async { // runloop?
            self.needsRebuild = true
            self.rebuildIfNeeded()
        }
    }

    private static func configureEnvironmentObjectProperties(of view: SomeView, context: Context) {
        let mirror = Mirror(reflecting: view)
        for (label, value) in mirror.children where label != nil {
            if var property = value as? EnvironmentObjectProperty {
                let key = property.storage.objectTypeIdentifier
                property.storage.get = {
                    if let object = context.environmentObjects[key] {
                        return object
                    } else {
                        fatalError("Environment object of type \(key) not found.")
                    }
                }
                property.storage.set = { _ in fatalError() }
            }
        }
    }
}

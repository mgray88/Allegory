//
// Created by Mike on 7/29/21.
//

import Foundation
protocol AnyUIKitNodeModifier {

    var hierarchyIdentifier: String { get}

    var isSpacer: Bool { get }

    var layoutPriority: Double { get }

    func update(viewModifier: SomeViewModifier, context: inout Context)

    func layoutSize(fitting targetSize: CGSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize

    func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode)
}

protocol UIKitNodeModifier: AnyUIKitNodeModifier {

    associatedtype ViewModifier: SomeViewModifier

    func update(viewModifier: ViewModifier, context: inout Context)
}

extension AnyUIKitNodeModifier {

    public var isSpacer: Bool {
        false
    }

    public var layoutPriority: Double {
        0
    }

    func update(viewModifier: SomeViewModifier, context: inout Context) {}

    func layoutSize(fitting targetSize: CGSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
        node.layoutSize(fitting: targetSize, pass: pass)
    }

    func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
        node.layout(in: container, bounds: bounds, pass: pass)
    }
}

extension UIKitNodeModifier {

    public func update(viewModifier: SomeViewModifier, context: inout Context) {
        update(viewModifier: viewModifier as! ViewModifier, context: &context)
    }
}

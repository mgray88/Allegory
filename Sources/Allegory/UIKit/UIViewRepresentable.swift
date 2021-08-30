//
// Created by Mike on 7/30/21.
//

import UIKit

public protocol SomeUIViewRepresentable: SomeView {
    func __makeCoordinator() -> Any
    func __makeUIView(context: Any) -> UIView
    func __updateUIView(_ uiView: UIView, context: Any)
    func __makeContext(context: Context, coordinator: Any) -> Any
}

/// A wrapper for a UIKit view that you use to integrate that view into your
/// Allegory view hierarchy.
public protocol UIViewRepresentable: SomeUIViewRepresentable, View where Body == Never {
    /// The type of view to present.
    associatedtype UIViewType: UIView

    /// A type to coordinate with the view.
    associatedtype Coordinator = Void

    typealias Context = UIViewRepresentableContext<Self>

    /// Creates the custom instance that you use to communicate changes from
    /// your view to other parts of your Allegory interface.
    ///
    /// - Returns:
    func makeCoordinator() -> Coordinator

    /// Creates the view object and configures its initial state.
    ///
    /// You must implement this method and use it to create your view object.
    /// Configure the view using your app’s current data and contents of the
    /// `context` parameter. The system calls this method only once, when it
    /// creates your view for the first time. For all subsequent updates, the
    /// system calls the ``updateUIView(_:context:)`` method.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    /// - Returns: Your UIKit view configured with the provided information.
    func makeUIView(context: Context) -> UIViewType

    /// Updates the state of the specified view with new information from
    /// Allegory.
    ///
    /// When the state of your app changes, Allegory updates the portions of
    /// your interface affected by those changes. Allegory calls this method for
    /// any changes affecting the corresponding UIKit view. Use this method to
    /// update the configuration of your view to match the new state information
    /// provided in the `context` parameter.
    ///
    /// - Parameters:
    ///   - uiView: Your custom view object.
    ///   - context: A context structure containing information about the
    ///     current state of the system.
    func updateUIView(_ uiView: UIViewType, context: Context)
}

public struct UIViewRepresentableContext<Representable> where Representable: UIViewRepresentable {
    public let coordinator: Representable.Coordinator

    public var environment: EnvironmentValues {
        context.environment
    }

    internal let context: Context
}

extension UIViewRepresentable where Coordinator == Void {
    public func makeCoordinator() {
    }
}

extension UIViewRepresentable {
    public func __makeCoordinator() -> Any {
        makeCoordinator()
    }

    public func __makeUIView(context: Any) -> UIView {
        makeUIView(context: context as! Context)
    }

    public func __updateUIView(_ uiView: UIView, context: Any) {
        updateUIView(uiView as! UIViewType, context: context as! Context)
    }

    public func __makeContext(context: Allegory.Context, coordinator: Any) -> Any {
        UIViewRepresentableContext<Self>(coordinator: coordinator as! Coordinator, context: context)
    }
}

extension UIViewRepresentable {}

class UIViewRepresentableNode: SomeUIKitNode {
    var hierarchyIdentifier: String {
        "\(type(of: uiView))"
    }

    var uiView: UIView!
    var coordinator: Any!

    func update(view: SomeView, context: Context) {
        let view = view as! SomeUIViewRepresentable
        if let uiView = self.uiView {
            let context = view.__makeContext(context: context, coordinator: coordinator as Any)
            view.__updateUIView(uiView, context: context)
        } else {
            self.coordinator = view.__makeCoordinator()
            let context = view.__makeContext(context: context, coordinator: coordinator as Any)
            self.uiView = view.__makeUIView(context: context)
            view.__updateUIView(self.uiView, context: context)
        }
    }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        let size = uiView.intrinsicContentSize
        return max(size, proposedSize.orMax)
    }

    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        uiView.frame = bounds.rect
        container.view.addSubview(uiView)
    }
}

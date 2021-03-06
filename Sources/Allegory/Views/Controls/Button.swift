//
// Created by Mike on 7/31/21.
//

import UIKit

/// A control that initiates an action.
///
/// You create a button by providing an action and a label. The action is either
/// a method or closure property that does something when a user clicks or taps
/// the button. The label is a view that describes the button’s action — for
/// example, by showing text, an icon, or both:
/// ```swift
/// Button(action: signIn) {
///     Text("Sign In")
/// }
/// ```
public struct Button<Label>: View where Label: View {
    public typealias Body = Swift.Never

    public let role: ButtonRole?
    public let label: Label
    public let action: () -> Void

    /// Creates a button that displays a custom label.
    ///
    /// - Parameters:
    ///   - action: The action to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button’s `action`.
    @inlinable
    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.role = nil
        self.action = action
        self.label = label()
    }

    /// Creates a button with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value
    ///     of `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user interacts with the
    ///     button.
    ///   - label: A view that describes the purpose of the button’s `action`.
    @inlinable
    public init(
        role: ButtonRole?,
        action: @escaping () -> Void,
        label: () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label()
    }
}

extension Button where Label == Text {
    /// Creates a button that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button’s `action`.
    ///   - action: The action to perform when the user triggers the button.
    @inlinable
    public init<S>(
        _ title: S,
        action: @escaping () -> Void
    ) where S: StringProtocol {
        self.role = nil
        self.action = action
        self.label = Text(title)
    }

    /// Creates a button with a specified role that generates its label from a
    /// string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)``.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button’s `action`.
    ///   - role: An optional semantic role describing the button. A value of
    ///     `nil` means that the button doesn’t have an assigned role.
    ///   - action: The action to perform when the user interacts with the
    ///     button.
    @inlinable
    public init<S>(
        _ title: S,
        role: ButtonRole?,
        action: @escaping () -> Void
    ) where S: StringProtocol {
        self.role = role
        self.action = action
        self.label = Text(title)
    }
}

extension Button: _PrimitiveView {
    func buildNodeTree(_ node: Node) {
        // TODO
    }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        TODO()
    }

    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        TODO()
    }
}

extension Button: UIKitNodeResolvable {
    private class ButtonNode: Control, UIKitNode {
        var hierarchyIdentifier: String {
            "Button<\(label.hierarchyIdentifier)>"
        }

        var view: Button!
        var label: SomeUIKitNode!

        // TODO: Switch to UIButton, or ensure accessibility is set correctly
        let control = Control()

        func update(view: Button, context: Context) {
            // TODO: Get ButtonStyle
            self.view = view
            var context = context
            context.environment.foregroundColor = context.environment.accentColor
            self.label = view.label.resolve(context: context, cachedNode: label)
            control.tappedHandler = view.action
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            label.size(fitting: proposedSize, pass: pass)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            self.frame = bounds.rect
            container.view.addSubview(self)
            label.render(
                in: container.replacingView(self),
                bounds: bounds.at(origin: .zero),
                pass: pass
            )
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? ButtonNode) ?? ButtonNode()
    }
}

extension Button {

    class Control: ContainerControl {

        var tappedHandler: (() -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            addTarget(self, action: #selector(tapped), for: .touchUpInside)
            addTarget(self, action: #selector(highlight), for: .touchDown)
            addTarget(self, action: #selector(unhighlight), for: .touchUpInside)
            addTarget(self, action: #selector(unhighlight), for: .touchUpOutside)
            addTarget(self, action: #selector(unhighlight), for: .touchCancel)
        }

        @available(*, unavailable)
        public required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private dynamic func unhighlight() {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.1,
                delay: 0,
                options: [],
                animations: { self.alpha = 1 },
                completion: nil
            )
        }

        @objc private dynamic func highlight() {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.1,
                delay: 0,
                options: [],
                animations: { self.alpha = 0.5 },
                completion: nil
            )
        }

        @objc func tapped() {
            tappedHandler?()
        }
    }
}

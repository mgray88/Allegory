//
// Created by Mike on 8/7/21.
//

import UIKit

public struct Toggle<Label>: View where Label: View {

    internal let isOn: Binding<Bool>
    internal let label: Label

    /// Creates a toggle that displays a custom label.
    ///
    /// - Parameters:
    ///   - isOn: A binding to a property that determines whether the toggle is on
    ///     or off.
    ///   - label: A view that describes the purpose of the toggle.
    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self.isOn = Binding(
            get: { isOn.get() },
            set: { isOn.set($0, $1) }
        )
        self.label = label()
    }
}

extension Toggle where Label == Text {
    /// Creates a toggle that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See `Text` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the toggle.
    ///   - isOn: A binding to a property that indicates whether the toggle is
    ///    on or off.
    public init<S>(_ title: S, isOn: Binding<Bool>) where S: StringProtocol {
        self.isOn = Binding(
            get: { isOn.get() },
            set: { isOn.set($0, $1) }
        )
        self.label = Text(title)
    }
}

extension Toggle: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "Toggle"
        }

        var toggle: Toggle<Label>!
        let control = Control()

        func update(view: Toggle<Label>, context: Context) {
            self.toggle = view
            control.binding = view.isOn
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            control.sizeThatFits(proposedSize.orDefault)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            container.view.addSubview(control)
            control.frame = bounds.rect
        }
    }

    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

extension Toggle {
    private class Control: UISwitch {
        internal var binding: Binding<Bool>? {
            didSet {
                guard let binding = binding else { return }
                isOn = binding.wrappedValue
            }
        }

        internal init() {
            super.init(frame: .zero)

            addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        }

        @available(*, unavailable)
        internal required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        private func valueChanged() {
            binding?.wrappedValue = isOn
        }
    }
}

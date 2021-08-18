//
// Created by Mike on 8/8/21.
//

import UIKit.UIStepper

/// A control that performs increment and decrement actions.
///
/// > Warning: WIP. Not yet implemented.
///
/// Use a stepper control when you want the user to have granular control while
/// incrementing or decrementing a value. For example, you can use a stepper
/// to:
///
///  * Change a value up or down by `1`.
///  * Operate strictly over a prescribed range.
///  * Step by specific amounts over a stepper's range of possible values.
///
/// The example below uses an array that holds a number of ``Color`` values,
/// a local state variable, `value`, to set the control's background
/// color, and title label. When the user clicks or taps on the stepper's
/// increment or decrement buttons Allegory executes the relevant
/// closure that updates `value`, wrapping the `value` to prevent overflow.
/// Allegory then re-renders the view, updating the text and background
/// color to match the current index:
///
///     struct StepperView: View {
///         @State private var value = 0
///         let colors: [Color] = [.orange, .red, .gray, .blue,
///                                .green, .purple, .pink]
///
///         func incrementStep() {
///             value += 1
///             if value >= colors.count { value = 0 }
///         }
///
///         func decrementStep() {
///             value -= 1
///             if value < 0 { value = colors.count - 1 }
///         }
///
///         var body: some View {
///             Stepper {
///                 Text("Value: \(value) Color: \(colors[value].description)")
///             } onIncrement: {
///                 incrementStep()
///             } onDecrement: {
///                 decrementStep()
///             }
///             .padding(5)
///             .background(colors[value])
///         }
///    }
///
/// The following example shows a stepper that displays the effect of
/// incrementing or decrementing a value with the step size of `step` with
/// the bounds defined by `range`:
///
///     struct StepperView: View {
///         @State private var value = 0
///         let step = 5
///         let range = 1...50
///
///         var body: some View {
///             Stepper(value: $value,
///                     in: range,
///                     step: step) {
///                 Text("Current: \(value) in \(range.description) " +
///                      "stepping by \(step)")
///             }
///                 .padding(10)
///         }
///     }
///
public struct Stepper<Label>: View where Label: View {

    internal let label: Label

    /// Creates a stepper instance that performs the closures you provide when
    /// the user increments or decrements the stepper.
    ///
    /// Use this initializer to create a control with a custom title that
    /// executes closures you provide when the user clicks or taps the
    /// stepper's increment or decrement buttons.
    ///
    /// The example below uses an array that holds a number of ``Color`` values,
    /// a local state variable, `value`, to set the control's background
    /// color, and title label. When the user clicks or taps on the stepper's
    /// increment or decrement buttons SwiftUI executes the relevant
    /// closure that updates `value`, wrapping the `value` to prevent overflow.
    /// SwiftUI then re-renders the view, updating the text and background
    /// color to match the current index:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///         let colors: [Color] = [.orange, .red, .gray, .blue, .green,
    ///                                .purple, .pink]
    ///
    ///         func incrementStep() {
    ///             value += 1
    ///             if value >= colors.count { value = 0 }
    ///         }
    ///
    ///         func decrementStep() {
    ///             value -= 1
    ///             if value < 0 { value = colors.count - 1 }
    ///         }
    ///
    ///         var body: some View {
    ///             Stepper {
    ///                 Text("Value: \(value) Color: \(colors[value].description)")
    ///             } onIncrement: {
    ///                 incrementStep()
    ///             } onDecrement: {
    ///                 decrementStep()
    ///             }
    ///             .padding(5)
    ///             .background(colors[value])
    ///         }
    ///    }
    ///
    /// - Parameters:
    ///     - label: A view describing the purpose of this stepper.
    ///     - onIncrement: The closure to execute when the user clicks or taps
    ///       the control's plus button.
    ///     - onDecrement: The closure to execute when the user clicks or taps
    ///       the control's minus button.
    ///     - onEditingChanged: A closure called when editing begins and ends.
    ///       For example, on iOS, the user may touch and hold the increment
    ///       or decrement buttons on a `Stepper` which causes the execution
    ///       of the `onEditingChanged` closure at the start and end of
    ///       the gesture.
    public init(
        @ViewBuilder label: () -> Label,
        onIncrement: (() -> Void)?,
        onDecrement: (() -> Void)?,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.label = label()
        TODO()
    }
}

extension Stepper {

    /// Creates a stepper configured to increment or decrement a binding to a
    /// value using a step value you provide.
    ///
    /// Use this initializer to create a stepper that increments or decrements
    /// a bound value by a specific amount each time the user
    /// clicks or taps the stepper's increment or decrement buttons.
    ///
    /// In the example below, a stepper increments or decrements `value` by the
    /// `step` value of 5 at each click or tap of the control's increment or
    /// decrement button:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 1
    ///         let step = 5
    ///         var body: some View {
    ///             Stepper(value: $value,
    ///                     step: step) {
    ///                 Text("Current value: \(value), step: \(step)")
    ///             }
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The ``Binding`` to a value that you provide.
    ///   - step: The amount to increment or decrement `value` each time the
    ///     user clicks or taps the stepper's increment or decrement buttons.
    ///     Defaults to `1`.
    ///   - label: A view describing the purpose of this stepper.
    ///   - onEditingChanged: A closure that's called when editing begins and
    ///     ends. For example, on iOS, the user may touch and hold the increment
    ///     or decrement buttons on a stepper which causes the execution
    ///     of the `onEditingChanged` closure at the start and end of
    ///     the gesture.
    public init<V>(
        value: Binding<V>,
        step: V.Stride = 1,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: Strideable {
        self.label = label()
        TODO()
    }

    /// Creates a stepper configured to increment or decrement a binding to a
    /// value using a step value and within a range of values you provide.
    ///
    /// Use this initializer to create a stepper that increments or decrements
    /// a binding to value by the step size you provide within the given bounds.
    /// By setting the bounds, you ensure that the value never goes below or
    /// above the lowest or highest value, respectively.
    ///
    /// The example below shows a stepper that displays the effect of
    /// incrementing or decrementing a value with the step size of `step`
    /// with the bounds defined by `range`:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///         let step = 5
    ///         let range = 1...50
    ///
    ///         var body: some View {
    ///             Stepper(value: $value,
    ///                     in: range,
    ///                     step: step) {
    ///                 Text("Current: \(value) in \(range.description) " +
    ///                      "stepping by \(step)")
    ///             }
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: A ``Binding`` to a value that you provide.
    ///   - bounds: A closed range that describes the upper and lower bounds
    ///     permitted by the stepper.
    ///   - step: The amount to increment or decrement the stepper when the
    ///     user clicks or taps the stepper's increment or decrement buttons,
    ///     respectively.
    ///   - label: A view describing the purpose of this stepper.
    ///   - onEditingChanged: A closure that's called when editing begins and
    ///     ends. For example, on iOS, the user may touch and hold the increment
    ///     or decrement buttons on a stepper which causes the execution
    ///     of the `onEditingChanged` closure at the start and end of
    ///     the gesture.
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V.Stride = 1,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: Strideable {
        self.label = label()
        TODO()
    }
}

extension Stepper where Label == Text {

    /// Creates a stepper using a title string and that executes closures
    /// you provide when the user clicks or taps the stepper's increment or
    /// decrement buttons.
    ///
    /// Use `Stepper(_:onIncrement:onDecrement:onEditingChanged:)` to create a
    /// control with a custom title that executes closures you provide when
    /// the user clicks or taps on the stepper's increment or decrement buttons.
    ///
    /// The example below uses an array that holds a number of ``Color`` values,
    /// a local state variable, `value`, to set the control's background
    /// color, and title label. When the user clicks or taps on the stepper's
    /// increment or decrement buttons SwiftUI executes the relevant
    /// closure that updates `value`, wrapping the `value` to prevent overflow.
    /// SwiftUI then re-renders the view, updating the text and background
    /// color to match the current index:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///         let title: String
    ///         let colors: [Color] = [.orange, .red, .gray, .blue, .green,
    ///                                .purple, .pink]
    ///
    ///         func incrementStep() {
    ///             value += 1
    ///             if value >= colors.count { value = 0 }
    ///         }
    ///
    ///         func decrementStep() {
    ///             value -= 1
    ///             if value < 0 { value = colors.count - 1 }
    ///         }
    ///
    ///         var body: some View {
    ///             Stepper(title, onIncrement: incrementStep, onDecrement: decrementStep)
    ///                 .padding(5)
    ///                 .background(colors[value])
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string describing the purpose of the stepper.
    ///     - onIncrement: The closure to execute when the user clicks or taps the
    ///       control's plus button.
    ///     - onDecrement: The closure to execute when the user clicks or taps the
    ///       control's minus button.
    ///    - onEditingChanged: A closure that's called when editing begins and
    ///      ends. For example, on iOS, the user may touch and hold the increment
    ///      or decrement buttons on a `Stepper` which causes the execution
    ///      of the `onEditingChanged` closure at the start and end of
    ///      the gesture.
    public init<S>(
        _ title: S,
        onIncrement: (() -> Void)?,
        onDecrement: (() -> Void)?,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol {
        self.label = Text(title)
        TODO()
    }

    /// Creates a stepper with a title and configured to increment and
    /// decrement a binding to a value and step amount you provide.
    ///
    /// Use `Stepper(_:value:step:onEditingChanged:)` to create a stepper with a
    /// custom title that increments or decrements a binding to value by the
    /// step size you specify.
    ///
    /// In the example below, the stepper increments or decrements the binding
    /// value by `5` each time one of the user clicks or taps the control's
    /// increment or decrement buttons:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 1
    ///         let step = 5
    ///         let title: String
    ///
    ///         var body: some View {
    ///             Stepper(title, value: $value, step: step)
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string describing the purpose of the stepper.
    ///     - value: The ``Binding`` to a value that you provide.
    ///     - step: The amount to increment or decrement `value` each time the
    ///       user clicks or taps the stepper's increment or decrement button,
    ///       respectively. Defaults to `1`.
    ///     - onEditingChanged: A closure that's called when editing begins and
    ///       ends. For example, on iOS, the user may touch and hold the
    ///       increment or decrement buttons on a `Stepper` which causes the
    ///       execution of the `onEditingChanged` closure at the start and end
    ///       of the gesture.
    public init<S, V>(
        _ title: S,
        value: Binding<V>,
        step: V.Stride = 1,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, V: Strideable {
        self.label = Text(title)
        TODO()
    }

    /// Creates a stepper instance that increments and decrements a binding to
    /// a value, by a step size and within a closed range that you provide.
    ///
    /// Use `Stepper(_:value:in:step:onEditingChanged:)` to create a stepper
    /// that increments or decrements a value within a specific range of values
    /// by a specific step size. In the example below, a stepper increments or
    /// decrements a binding to value over a range of `1...50` by `5` each time
    /// the user clicks or taps the stepper's increment or decrement buttons:
    ///
    ///     struct StepperView: View {
    ///         @State private var value = 0
    ///         let step = 5
    ///         let range = 1...50
    ///
    ///         var body: some View {
    ///             Stepper("Current: \(value) in \(range.description) stepping by \(step)",
    ///                     value: $value,
    ///                     in: range,
    ///                     step: step)
    ///                 .padding(10)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string describing the purpose of the stepper.
    ///     - value: A ``Binding`` to a value that your provide.
    ///     - bounds: A closed range that describes the upper and lower bounds
    ///       permitted by the stepper.
    ///     - step: The amount to increment or decrement `value` each time the
    ///       user clicks or taps the stepper's increment or decrement button,
    ///       respectively. Defaults to `1`.
    ///     - onEditingChanged: A closure that's called when editing begins and
    ///       ends. For example, on iOS, the user may touch and hold the increment
    ///       or decrement buttons on a `Stepper` which causes the execution
    ///       of the `onEditingChanged` closure at the start and end of
    ///       the gesture.
    public init<S, V>(
        _ title: S,
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V.Stride = 1,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where S: StringProtocol, V: Strideable {
        self.label = Text(title)
        TODO()
    }
}

extension Stepper: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "Stepper"
        }

        let control = Control()

        func update(view: Stepper<Label>, context: Context) {
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            control.size(fitting: proposedSize)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        }
    }

    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

extension Stepper {
    private class Control: UIStepper, UIControlRenderable {
        func size(fitting proposedSize: ProposedSize) -> CGSize {
            sizeThatFits(proposedSize.orDefault)
        }

        internal init() {
            super.init(frame: .zero)

            addTarget(self, action: #selector(valueChanged), for: .valueChanged)
            addTarget(self, action: #selector(startEdit), for: .touchDown)
            addTarget(self, action: #selector(endEdit), for: .touchUpInside)
            addTarget(self, action: #selector(endEdit), for: .touchUpOutside)
            addTarget(self, action: #selector(endEdit), for: .touchCancel)
        }

        @available(*, unavailable)
        internal required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        private func valueChanged() {
        }

        @objc
        private func startEdit() {
        }

        @objc
        private func endEdit() {
        }
    }
}

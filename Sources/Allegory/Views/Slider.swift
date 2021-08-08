//
// Created by Mike on 8/7/21.
//

import UIKit

/// A control for selecting a value from a bounded linear range of values.
///
/// > Warning: Labels not implemented
///
/// A slider consists of a "thumb" image that the user moves between two
/// extremes of a linear "track". The ends of the track represent the minimum
/// and maximum possible values. As the user moves the thumb, the slider
/// updates its bound value.
///
/// The following example shows a slider bound to the value `speed`. As the
/// slider updates this value, a bound ``Text`` view shows the value updating.
/// The `onEditingChanged` closure passed to the slider receives callbacks when
/// the user drags the slider. The example uses this to change the
/// color of the value text.
///
///     @State private var speed = 50.0
///     @State private var isEditing = false
///
///     var body: some View {
///         VStack {
///             Slider(
///                 value: $speed,
///                 in: 0...100,
///                 onEditingChanged: { editing in
///                     isEditing = editing
///                 }
///             )
///             Text("\(speed)")
///                 .foregroundColor(isEditing ? .red : .blue)
///         }
///     }
///
/// You can also use a `step` parameter to provide incremental steps along the
/// path of the slider. For example, if you have a slider with a range of `0` to
/// `100`, and you set the `step` value to `5`, the slider's increments would be
/// `0`, `5`, `10`, and so on. The following example shows this approach, and
/// also adds optional minimum and maximum value labels.
///
///     @State private var speed = 50.0
///     @State private var isEditing = false
///
///     var body: some View {
///         Slider(
///             value: $speed,
///             in: 0...100,
///             step: 5
///         ) {
///             Text("Speed")
///         } minimumValueLabel: {
///             Text("0")
///         } maximumValueLabel: {
///             Text("100")
///         } onEditingChanged: { editing in
///             isEditing = editing
///         }
///         Text("\(speed)")
///             .foregroundColor(isEditing ? .red : .blue)
///     }
///
/// The slider also uses the `step` to increase or decrease the value when a
/// VoiceOver user adjusts the slider with voice commands.
public struct Slider<Label, ValueLabel>: View
    where Label: View, ValueLabel: View {

    internal let binding: Binding<Float>
    internal let bounds: ClosedRange<Float>
    internal let step: Float

    internal let label: Label?
    internal let minimumValueLabel: ValueLabel?
    internal let maximumValueLabel: ValueLabel?

    internal let onEditingChanged: (Bool) -> Void
}

extension Slider {
    /// Creates a slider to select a value from a given range, which displays
    /// the provided labels.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, Allegory
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - minimumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - maximumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V> = 0...1,
        @ViewBuilder label: () -> Label,
        @ViewBuilder minimumValueLabel: () -> ValueLabel,
        @ViewBuilder maximumValueLabel: () -> ValueLabel,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
        self.binding = Binding(
            get: { Float(value.get()) },
            set: { value.set(V($0), $1) }
        )
        self.bounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        self.step = Float(0.01)
        self.label = label()
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
        self.onEditingChanged = onEditingChanged
    }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment, which displays the provided labels.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, Allegory
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - minimumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - maximumValueLabel: A view that describes `bounds.lowerBound`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V.Stride = 1,
        @ViewBuilder label: () -> Label,
        @ViewBuilder minimumValueLabel: () -> ValueLabel,
        @ViewBuilder maximumValueLabel: () -> ValueLabel,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
        self.binding = Binding(
            get: { Float(value.get()) },
            set: { value.set(V($0), $1) }
        )
        self.bounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        self.step = Float(step)
        self.label = label()
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
        self.onEditingChanged = onEditingChanged
    }
}

extension Slider where ValueLabel == EmptyView {
    /// Creates a slider to select a value from a given range, which displays
    /// the provided label.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, Allegory
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V> = 0...1,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
        self.binding = Binding(
            get: { Float(value.get()) },
            set: { value.set(V($0), $1) }
        )
        self.bounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        self.step = Float(0.01)
        self.label = label()
        self.minimumValueLabel = nil
        self.maximumValueLabel = nil
        self.onEditingChanged = onEditingChanged
    }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment, which displays the provided label.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - label: A `View` that describes the purpose of the instance. Not all
    ///     slider styles show the label, but even in those cases, Allegory
    ///     uses the label for accessibility. For example, VoiceOver uses the
    ///     label to identify the purpose of the slider.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V.Stride = 1,
        @ViewBuilder label: () -> Label,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
        self.binding = Binding(
            get: { Float(value.get()) },
            set: { value.set(V($0), $1) }
        )
        self.bounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        self.step = Float(step)
        self.label = label()
        self.minimumValueLabel = nil
        self.maximumValueLabel = nil
        self.onEditingChanged = onEditingChanged
    }
}

extension Slider where Label == EmptyView, ValueLabel == EmptyView {
    /// Creates a slider to select a value from a given range.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V> = 0...1,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
        self.binding = Binding(
            get: { Float(value.get()) },
            set: { value.set(V($0), $1) }
        )
        self.bounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        self.step = Float(0.01)
        self.label = nil
        self.minimumValueLabel = nil
        self.maximumValueLabel = nil
        self.onEditingChanged = onEditingChanged
    }

    /// Creates a slider to select a value from a given range, subject to a
    /// step increment.
    ///
    /// - Parameters:
    ///   - value: The selected value within `bounds`.
    ///   - bounds: The range of the valid values. Defaults to `0...1`.
    ///   - step: The distance between each valid value.
    ///   - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance is equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// The slider calls `onEditingChanged` when editing begins and ends. For
    /// example, on iOS, editing begins when the user starts to drag the thumb
    /// along the slider's track.
    @available(tvOS, unavailable)
    public init<V>(
        value: Binding<V>,
        in bounds: ClosedRange<V>,
        step: V.Stride = 1,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V: BinaryFloatingPoint, V.Stride: BinaryFloatingPoint {
        self.binding = Binding(
            get: { Float(value.get()) },
            set: { value.set(V($0), $1) }
        )
        self.bounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        self.step = Float(step)
        self.label = nil
        self.minimumValueLabel = nil
        self.maximumValueLabel = nil
        self.onEditingChanged = onEditingChanged
    }
}

extension Slider: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "Slider"
        }

        let control = Control()

        func update(view: Slider<Label, ValueLabel>, context: Context) {
            control.binding = view.binding
            control.minimumValue = view.bounds.lowerBound
            control.maximumValue = view.bounds.upperBound
            control.step = view.step
            control.onEditingChanged = view.onEditingChanged
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            control.sizeThatFits(proposedSize.orDefault)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            container.view.addSubview(control)
            control.frame = bounds.rect
            control.accessibilityFrame = control.convert(bounds.rect, to: nil)
        }
    }

    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

extension Slider {
    private class Control: UISlider {
        internal var binding: Binding<Float>? {
            didSet {
                guard let binding = binding else { return }
                value = binding.wrappedValue
            }
        }

        internal var step: Float = 1
        internal var onEditingChanged: ((Bool) -> Void)?

        internal init() {
            super.init(frame: .zero)
            isContinuous = true

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
            let steppedValue = round(value / step) * step
            binding?.wrappedValue = steppedValue
        }

        @objc
        private func startEdit() {
            onEditingChanged?(true)
        }

        @objc
        private func endEdit() {
            onEditingChanged?(false)

            let steppedValue = round(value / step) * step
            self.value = steppedValue
        }
    }
}

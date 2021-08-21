//
// Created by Mike on 8/18/21.
//

extension View {

    /// Sets the view's horizontal alignment.
    ///
    /// Use `alignmentGuide(_:computeValue:)` to calculate specific offsets
    /// to reposition views in relationship to one another. You can return a
    /// constant or can use the ``ViewDimensions`` argument to the closure to
    /// calculate a return value.
    ///
    /// In the example below, the ``HStack`` is offset by a constant of 50
    /// points to the right of center:
    ///
    ///     VStack {
    ///         Text("Today's Weather")
    ///             .font(.title)
    ///             .border(Color.gray)
    ///         HStack {
    ///             Text("🌧")
    ///             Text("Rain & Thunderstorms")
    ///             Text("⛈")
    ///         }
    ///         .alignmentGuide(HorizontalAlignment.center) { _ in  50 }
    ///         .border(Color.gray)
    ///     }
    ///     .border(Color.gray)
    ///
    /// Changing the alignment of one view may have effects on surrounding
    /// views. Here the offset values inside a stack and its contained views is
    /// the difference of their absolute offsets.
    ///
    /// - Parameters:
    ///   - g: A ``HorizontalAlignment`` value at which to base the offset.
    ///   - computeValue: A closure that returns the offset value to apply to
    ///     this view.
    ///
    /// - Returns: A view modified with respect to its horizontal alignment
    ///   according to the computation performed in the method's closure.
    @inlinable
    public func alignmentGuide(
        _ g: HorizontalAlignment,
        computeValue: @escaping (ViewDimensions) -> CGFloat
    ) -> ModifiedContent<Self, _AlignmentWritingModifier> {
        modifier(
            _AlignmentWritingModifier(key: g.key, computeValue: computeValue)
        )
    }

    /// Sets the view's vertical alignment.
    ///
    /// Use `alignmentGuide(_:computeValue:)` to calculate specific offsets
    /// to reposition views in relationship to one another. You can return a
    /// constant or can use the ``ViewDimensions`` argument to the closure to
    /// calculate a return value.
    ///
    /// In the example below, the weather emoji are offset 20 points from the
    /// vertical center of the ``HStack``.
    ///
    ///     VStack {
    ///         Text("Today's Weather")
    ///             .font(.title)
    ///             .border(Color.gray)
    ///
    ///         HStack {
    ///             Text("🌧")
    ///                 .alignmentGuide(VerticalAlignment.center) { _ in -20 }
    ///             Text("Rain & Thunderstorms")
    ///                 .border(Color.gray)
    ///             Text("⛈")
    ///                 .alignmentGuide(VerticalAlignment.center) { _ in 20 }
    ///                 .border(Color.gray)
    ///         }
    ///     }
    ///
    /// Changing the alignment of one view may have effects on surrounding
    /// views. Here the offset values inside a stack and its contained views is
    /// the difference of their absolute offsets.
    ///
    /// - Parameters:
    ///   - g: A ``VerticalAlignment`` value at which to base the offset.
    ///   - computeValue: A closure that returns the offset value to apply to
    ///     this view.
    ///
    /// - Returns: A view modified with respect to its vertical alignment
    ///   according to the computation performed in the method's closure.
    @inlinable
    public func alignmentGuide(
        _ g: VerticalAlignment,
        computeValue: @escaping (ViewDimensions) -> CGFloat
    ) -> ModifiedContent<Self, _AlignmentWritingModifier> {
        modifier(
            _AlignmentWritingModifier(key: g.key, computeValue: computeValue)
        )
    }
}

public struct _AlignmentWritingModifier: ViewModifier {
    @usableFromInline
    internal let key: AlignmentKey

    @usableFromInline
    internal let computeValue: (ViewDimensions) -> CGFloat

    @inlinable
    internal init(
        key: AlignmentKey,
        computeValue: @escaping (ViewDimensions) -> CGFloat
    ) {
        self.key = key
        self.computeValue = computeValue
    }

    public typealias Body = Never
}

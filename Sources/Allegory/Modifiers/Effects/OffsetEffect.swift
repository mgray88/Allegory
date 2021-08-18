//
// Created by Mike on 8/14/21.
//

public struct _OffsetEffect: GeometryEffect, Equatable {
    public var offset: CGSize

    @inlinable
    public init(offset: CGSize) {
        self.offset = offset
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        .init(.init(translationX: offset.width, y: offset.height))
    }

    public var animatableData: CGSize.AnimatableData {
        get {
            offset.animatableData
        }
        set {
            offset.animatableData = newValue
        }
    }

    public func body(content: Content) -> SomeView {
        content
    }
}

extension View {

    /// Offset this view by the horizontal and vertical amount specified in the
    /// offset parameter.
    ///
    /// Use `offset(_:)` to shift the displayed contents by the amount specified
    /// in the `offset` parameter.
    ///
    /// - Parameter offset: The distance to offset this view.
    /// - Returns: A view that offsets this view by `offset`.
    @inlinable
    public func offset(
        _ offset: CGSize
    ) -> ModifiedContent<Self, _OffsetEffect> {
        modifier(_OffsetEffect(offset: offset))
    }

    /// Offset this view by the specified horizontal and vertical distances.
    ///
    /// Use `offset(x:y:)` to shift the displayed contents by the amount
    /// specified in the `x` and `y` parameters.
    ///
    /// - Parameters:
    ///   - x: The horizontal distance to offset this view.
    ///   - y: The vertical distance to offset this view.
    /// - Returns: A view that offsets this view by `x` and `y`.
    @inlinable
    public func offset(
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> ModifiedContent<Self, _OffsetEffect> {
        offset(CGSize(width: x, height: y))
    }
}

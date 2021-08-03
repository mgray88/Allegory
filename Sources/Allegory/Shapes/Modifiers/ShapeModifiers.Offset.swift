//
// Created by Mike on 7/31/21.
//

extension Shape {
    /// Changes the relative position of this shape using the specified size.
    ///
    /// - Parameter offset: The amount, in points, by which you offset the
    ///   shape. Negative numbers are to the left and up; positive numbers are
    ///   to the right and down.
    /// - Returns: A shape offset by the specified amount.
    @inlinable
    public func offset(_ offset: CGSize) -> OffsetShape<Self> {
        OffsetShape(shape: self, offset: offset)
    }

    /// Changes the relative position of this shape using the specified point.
    ///
    /// - Parameter offset: The amount, in points, by which you offset the
    ///   shape. Negative numbers are to the left and up; positive numbers are
    ///   to the right and down.
    /// - Returns: A shape offset by the specified amount.
    @inlinable
    public func offset(_ offset: CGPoint) -> OffsetShape<Self> {
        OffsetShape(shape: self, offset: .init(width: offset.x, height: offset.y))
    }

    /// Changes the relative position of this shape using the specified point.
    ///
    /// - Parameters:
    ///   - x: The horizontal amount, in points, by which you offset the shape.
    ///     Negative numbers are to the left and positive numbers are to the
    ///     right.
    ///   - y: The vertical amount, in points, by which you offset the shape.
    ///     Negative numbers are up and positive numbers are down.
    /// - Returns: A shape offset by the specified amount.
    @inlinable
    public func offset(x: CGFloat = 0, y: CGFloat = 0) -> OffsetShape<Self> {
        OffsetShape(shape: self, offset: .init(width: x, height: y))
    }
}

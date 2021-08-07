//
// Created by Mike on 7/31/21.
//

extension Shape {
    /// Fills this shape with a color or gradient.
    ///
    /// > Warning: `style` is not currently used.
    ///
    /// - Parameters:
    ///   - content: The color or gradient to use when filling this shape.
    ///   - style: The style options that determine how the fill renders.
    /// - Returns: A shape filled with the color or gradient you supply.
    @inlinable
    public func fill<S>(
        _ content: S,
        style: FillStyle = FillStyle()
    ) -> _ShapeView<Self, S> where S: ShapeStyle {
        _ShapeView(shape: self, style: content)
    }

    /// Fills this shape with the foreground color.
    ///
    /// > Warning: `style` is not currently used.
    ///
    /// - Parameter style: The style options that determine how the fill
    ///   renders.
    /// - Returns: A shape filled with the foreground color.
    @inlinable public func fill(
        style: FillStyle = FillStyle()
    ) -> _ShapeView<Self, ForegroundStyle> {
        _ShapeView(shape: self, style: ForegroundStyle())
    }
}

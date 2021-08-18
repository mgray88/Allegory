//
// Created by Mike on 7/30/21.
//

extension Shape {
    @inlinable
    public func stroke(style: StrokeStyle) -> _StrokedShape<Self> {
        _StrokedShape(shape: self, style: style)
    }

    @inlinable
    public func stroke(lineWidth: CGFloat = 1) -> _StrokedShape<Self> {
        stroke(style: StrokeStyle(lineWidth: lineWidth))
    }
}

extension Shape {
    /// Returns a new shape that is a stroked copy of `self`, using the
    /// contents of `style` to define the stroke characteristics.
    ///
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - style: The stroke characteristics --- such as the line's width and
    ///     whether the stroke is dashed --- that determine how to render this
    ///     shape.
    /// - Returns: A stroked shape.
    public func stroke<S>(
        _ content: S,
        style: StrokeStyle
    ) -> _ShapeView<_StrokedShape<Self>, S> where S: ShapeStyle {
        _ShapeView(
            shape: _StrokedShape(shape: self, style: style),
            style: content
        )
    }

    /// Returns a new shape that is a stroked copy of `self` with
    /// line-width defined by `lineWidth` and all other properties of
    /// `StrokeStyle` having their default values.
    ///
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - lineWidth: The width of the stroke that outlines this shape.
    /// - Returns: A stroked shape.
    public func stroke<S>(
        _ content: S,
        lineWidth: CGFloat = 1
    ) -> _ShapeView<_StrokedShape<Self>, S> where S: ShapeStyle {
        stroke(content, style: StrokeStyle(lineWidth: lineWidth))
    }
}

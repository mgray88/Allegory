//
// Created by Mike on 7/30/21.
//

public protocol SomeInsettableShape: SomeShape {
    func inset(by amount: CGFloat) -> SomeInsettableShape
}

/// A shape type that is able to inset itself to produce another shape.
public protocol InsettableShape: Shape, SomeInsettableShape {
    associatedtype InsetShape: InsettableShape

    func inset(by amount: CGFloat) -> Self.InsetShape
}

extension InsettableShape {
    public func inset(by amount: CGFloat) -> SomeInsettableShape {
        inset(by: amount) as InsetShape
    }
}

extension InsettableShape {
    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with `content`.
    @inlinable
    public func strokeBorder<S>(
        _ content: S,
        style: StrokeStyle,
        antialiased: Bool = true
    ) -> _ShapeView<_StrokedShape<Self.InsetShape>, S> where S : ShapeStyle {
        inset(by: style.lineWidth / 2)
            .stroke(content)
    }

    /// Returns a view that is the result of insetting `self` by
    /// `style.lineWidth / 2`, stroking the resulting shape with
    /// `style`, and then filling with the foreground color.
    @inlinable
    public func strokeBorder(
        style: StrokeStyle,
        antialiased: Bool = true
    ) -> _ShapeView<_StrokedShape<Self.InsetShape>, ForegroundStyle> {
        inset(by: style.lineWidth / 2)
            .stroke(ForegroundStyle(), style: style)
    }

    /// Returns a view that is the result of filling the `width`-sized
    /// border (aka inner stroke) of `self` with `content`. This is
    /// equivalent to insetting `self` by `width / 2` and stroking the
    /// resulting shape with `width` as the line-width.
    @inlinable
    public func strokeBorder<S>(
        _ content: S,
        lineWidth: CGFloat = 1,
        antialiased: Bool = true
    ) -> _ShapeView<_StrokedShape<Self.InsetShape>, S> where S : ShapeStyle {
        inset(by: lineWidth / 2)
            .stroke(content, lineWidth: lineWidth)
    }


    /// Returns a view that is the result of filling the `width`-sized
    /// border (aka inner stroke) of `self` with the foreground color.
    /// This is equivalent to insetting `self` by `width / 2` and
    /// stroking the resulting shape with `width` as the line-width.
    @inlinable
    public func strokeBorder(
        lineWidth: CGFloat = 1,
        antialiased: Bool = true
    ) -> _ShapeView<_StrokedShape<Self.InsetShape>, ForegroundStyle> {
        inset(by: lineWidth / 2)
            .stroke(ForegroundStyle(), lineWidth: lineWidth)
    }
}

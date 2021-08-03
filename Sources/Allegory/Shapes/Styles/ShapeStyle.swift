//
// Created by Mike on 7/31/21.
//

public protocol ShapeStyle: SomeShapeStyle {
    func `in`(_ rect: CGRect) -> ShapeStyle
}

extension ShapeStyle {
    public func `in`(_ rect: CGRect) -> SomeShapeStyle {
        (`in`(rect) as ShapeStyle) as SomeShapeStyle
    }

    public func `in`(_ rect: CGRect) -> ShapeStyle {
        _AnchoredShapeStyle(content: self, anchor: rect)
    }
}

/// Default View.body implementation to fill a Rectangle with `self`.
extension ShapeStyle where Self: View, Self.Body == _ShapeView<Rectangle, Self> {

    public var body: _ShapeView<Rectangle, Self> {
        _ShapeView(shape: Rectangle(), style: self)
    }
}

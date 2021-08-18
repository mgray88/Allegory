//
// Created by Mike on 8/1/21.
//

public struct _AnchoredShapeStyle<S: ShapeStyle>: ShapeStyle {
    public let style: S
    public let bounds: CGRect

    @inlinable
    internal init(style: S, bounds: CGRect) {
        self.style = style
        self.bounds = bounds
    }
}

extension _AnchoredShapeStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        // TODO
        (style as? ShapeStyleRenderable)?
            .render(to: layer, context: context)
    }
}

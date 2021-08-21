//
// Created by Mike on 8/1/21.
//

/// Protocol which Shapes should conform to, to render their content with a
/// given style to the specified layer
protocol ShapeRenderable {
    func render<Style: ShapeStyle>(
        style: Style,
        to layer: CAShapeLayer,
        rect: CGRect,
        context: Context
    )
}

extension ShapeRenderable where Self: Shape {
    func render<Style: ShapeStyle>(
        style: Style,
        to layer: CAShapeLayer,
        rect: CGRect,
        context: Context
    ) {
        (style as? ShapeStyleRenderable)?.render(to: layer, context: context)
        layer.path = path(in: rect).cgPath
    }
}

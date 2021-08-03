//
// Created by Mike on 8/1/21.
//

public struct _AnchoredShapeStyle<Content: ShapeStyle>: ShapeStyle {
    internal let content: Content
    internal let anchor: CGRect
}

extension _AnchoredShapeStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        // TODO
        (content as? ShapeStyleRenderable)?
            .render(to: layer, context: context)
    }
}

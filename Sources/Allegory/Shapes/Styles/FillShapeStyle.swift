//
// Created by Mike on 7/31/21.
//

public struct FillShapeStyle: ShapeStyle {
    public let content: ShapeStyle

    @inlinable
    public init(content: ShapeStyle) {
        self.content = content
    }
}

extension FillShapeStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        (content as! ShapeStyleRenderable).render(to: layer, context: context)
        layer.strokeColor = nil
    }
}

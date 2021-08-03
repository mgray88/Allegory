//
// Created by Mike on 7/31/21.
//

public struct BackgroundStyle: ShapeStyle {
    @inlinable public init() {}
}

extension BackgroundStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        // TODO
//        layer.backgroundColor = context.environment
    }
}

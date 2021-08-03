//
// Created by Mike on 7/31/21.
//

public struct ForegroundStyle: ShapeStyle {
    @inlinable public init() {}
}

extension ForegroundStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        layer.fillColor = context.environment.foregroundColor?.cgColor
    }
}

//
// Created by Mike on 7/29/21.
//

public struct _ShapeView<S, SS>: View
    where S: Shape, SS: ShapeStyle {

    public typealias Body = Swift.Never

    public let shape: S
    public let style: SS

    @inlinable
    public init(shape: S, style: SS) {
        self.shape = shape
        self.style = style
    }

    internal func render(
        to layer: CAShapeLayer,
        bounds: Bounds,
        context: Context
    ) {
        print(String(reflecting: Self.self))
        (shape as? ShapeRenderable)?
            .render(style: style, to: layer, bounds: bounds, context: context)
//        layer.path = shape.path(in: bounds.rect).cgPath
//        if let color = style.resolve(
//            for: .resolveStyle(levels: 0..<1),
//            in: context.environment,
//            role: S.role
//        )?.color(at: 0) {
//            layer.fillColor = color.cgColor
//        } else if let foregroundStyle = context.environment._foregroundStyle,
//                  let color = foregroundStyle.resolve(
//                      for: .resolveStyle(levels: 0..<1),
//                      in: context.environment,
//                      role: S.role
//                  )?.color(at: 0) {
//            layer.fillColor = color.cgColor
//        }
    }
}

extension _ShapeView: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "ShapeView<\(S.typeIdentifier),ShapeStyle>"
        }

        let layer = CAShapeLayer()
        var makePath: ((CGRect) -> Path)!
        var render: ((CAShapeLayer, Bounds) -> Void)!

        func update(view: _ShapeView<S, SS>, context: Context) {
            makePath = view.shape.path(in:)
            render = { layer, bounds in
                view.render(to: layer, bounds: bounds, context: context)
            }
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            proposedSize.orDefault
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            render(layer, bounds)
            layer.removeAllAnimations()
            // TODO: Do we need to remove a layer first?
            // Say if a node is cached, but needs to be relayouted
            container.layer.addSublayer(layer)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

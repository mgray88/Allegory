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
        (shape as? ShapeRenderable)?
            .render(style: style, to: layer, bounds: bounds, context: context)
    }
}

extension _ShapeView: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "ShapeView"
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

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            proposedSize.orDefault
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
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

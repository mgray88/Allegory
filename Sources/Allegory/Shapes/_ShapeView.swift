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
        rect: CGRect,
        context: Context
    ) {
        print(String(reflecting: Self.self))
        (shape as? ShapeRenderable)?
            .render(style: style, to: layer, rect: rect, context: context)
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

    private class Node: UIView, UIKitNode {
        override class var layerClass: AnyClass {
            CAShapeLayer.self
        }

        override var layer: CAShapeLayer {
            super.layer as! CAShapeLayer
        }

        var hierarchyIdentifier: String {
            "ShapeView<\(S.typeIdentifier),ShapeStyle>"
        }

        var makePath: ((CGRect) -> Path)!
        var render: ((CAShapeLayer, CGRect) -> Void)!

        func update(view: _ShapeView<S, SS>, context: Context) {
            makePath = view.shape.path(in:)
            render = { layer, rect in
                view.render(to: layer, rect: rect, context: context)
            }
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            proposedSize.orDefault
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            frame = bounds.rect
            let bounds = bounds.at(origin: .zero)
            let path = makePath(bounds.rect)
            layer.path = path.cgPath
            render(layer, bounds.rect)
            container.view.addSubview(self)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

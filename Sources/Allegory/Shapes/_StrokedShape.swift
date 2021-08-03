//
// Created by Mike on 8/1/21.
//

public struct _StrokedShape<Content: Shape>: Shape {
    internal let content: Content
    internal let strokeStyle: StrokeStyle

    public func path(in rect: CGRect) -> Path {
        content.path(in: rect)
    }
}

//extension _StrokedShape: InsettableShape {
//    public struct _Inset: Shape, InsettableShape {
//        private let inset: CGFloat
//        internal init(inset: CGFloat) {
//            self.inset = inset
//        }
//
//        public func path(in rect: CGRect) -> Path {
//            Path(rect.insetBy(dx: inset, dy: inset))
//        }
//
//        public func inset(by amount: CGFloat) -> Self {
//            _Inset(inset: inset + amount)
//        }
//    }
//
//    public func inset(by amount: CGFloat) -> _Inset {
//        _Inset(inset: amount)
//    }
//}

extension _StrokedShape: ShapeRenderable {
    func render<Style: ShapeStyle>(
        style: Style,
        to layer: CAShapeLayer,
        bounds: Bounds,
        context: Context
    ) {
        (style as? ShapeStyleRenderable)?.render(to: layer, context: context)
        layer.path = path(in: bounds.rect).cgPath
        strokeStyle.apply(to: layer, context: context)
    }
}

//extension _StrokedShape._Inset: ShapeRenderable {
//    func render<Style: ShapeStyle>(
//        style: Style,
//        to layer: CAShapeLayer,
//        bounds: Bounds,
//        context: Context
//    ) {
//        (style as? ShapeStyleRenderable)?.render(to: layer, context: context)
//        layer.path = path(in: bounds.rect).cgPath
//        strokeStyle.apply(to: layer, context: context)
//    }
//}

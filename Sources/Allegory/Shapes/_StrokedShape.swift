//
// Created by Mike on 8/1/21.
//

public struct _StrokedShape<S: Shape>: Shape {
    public var shape: S
    public var style: StrokeStyle

    @inlinable
    public init(shape: S, style: StrokeStyle) {
        self.shape = shape
        self.style = style
    }

    public func path(in rect: CGRect) -> Path {
        shape
            .path(in: rect)
            .strokedPath(style)
    }

    public typealias AnimatableData = AnimatablePair<S.AnimatableData, StrokeStyle.AnimatableData>
    public var animatableData: AnimatablePair<S.AnimatableData, StrokeStyle.AnimatableData> {
        get {
            .init(
                shape.animatableData,
                style.animatableData
            )
        }
        set {
            shape.animatableData = newValue.first
            style.animatableData = newValue.second
        }
    }

    public typealias Body = _ShapeView<_StrokedShape<S>, ForegroundStyle>
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
        rect: CGRect,
        context: Context
    ) {
        layer.path = path(in: rect).cgPath
        self.style.render(to: layer, context: context)
        (style as? ShapeStyleRenderable)?.render(to: layer, context: context)
        layer.fillColor = nil
//        style.render(to: layer, context: context)
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

//
// Created by Mike on 8/5/21.
//

extension ViewModifiers {
    public struct _ClipShape<S: Shape>: ViewModifier {
        public let shape: S

        @inlinable
        public init(_ shape: S) {
            self.shape = shape
        }
    }
}

extension View {

//    @inlinable
//    public func clipShape<S: Shape>(
//        _ shape: S
//    ) -> ModifiedContent<Self, ViewModifiers._ClipShape<S>> {
//        modifier(ViewModifiers._ClipShape(shape))
//    }
//
//    @inlinable
//    public func clipped(
//    ) -> ModifiedContent<Self, ViewModifiers._ClipShape<Rectangle>> {
//        modifier(ViewModifiers._ClipShape(Rectangle()))
//    }
//
//    @inlinable
//    public func cornerRadius(
//        _ radius: Double
//    ) -> ModifiedContent<Self, ViewModifiers._ClipShape<RoundedRectangle>> {
//        modifier(
//            ViewModifiers._ClipShape(RoundedRectangle(cornerRadius: radius))
//        )
//    }

    @inlinable
    public func cornerRadius(
        _ radius: Double,
        corners: UIRectCorner
    ) -> ModifiedContent<Self, ViewModifiers._ClipShape<Corners>> {
        modifier(
            ViewModifiers._ClipShape(Corners(radius: radius, corners: corners))
        )
    }
}

extension ViewModifiers._ClipShape: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "ClipShape"
        }

        let clippingView = ClippingView()

        func update(viewModifier: ViewModifiers._ClipShape<S>, context: inout Context) {
            clippingView.makePath = viewModifier.shape.path(in:)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            clippingView.frame = bounds.rect
            clippingView.layoutIfNeeded()
            container.view.addSubview(clippingView)
            clippingView.replaceSubnodes {
                node.render(
                    in: container.replacingView(clippingView),
                    bounds: bounds.at(origin: .zero),
                    pass: pass
                )
            }
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

extension ViewModifiers._ClipShape {
    class ClippingView: ContainerView {
        var makePath: ((CGRect) -> Path)?
        let maskLayer = CAShapeLayer()

        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.mask = maskLayer
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            maskLayer.path = makePath?(bounds).cgPath
        }
    }
}

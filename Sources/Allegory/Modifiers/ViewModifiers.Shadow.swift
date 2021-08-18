//
// Created by Mike on 7/31/21.
//

extension ViewModifiers {
    public struct _Shadow: ViewModifier {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat

        @inlinable
        public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
            self.color = color
            self.radius = radius
            self.x = x
            self.y = y
        }
    }
}

extension View {
    /// Adds a shadow to this view.
    ///
    /// - Parameters:
    ///   - color: The shadow’s color.
    ///   - radius: The shadow’s size.
    ///   - x: A horizontal offset you use to position the shadow relative to
    ///     this view.
    ///   - y: A vertical offset you use to position the shadow relative to this
    ///     view.
    /// - Returns: A view that adds a shadow to this view.
    @inlinable
    public func shadow(
        color: Color = Color(white: 0, opacity: 0.33),
        radius: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> ModifiedContent<Self, ViewModifiers._Shadow> {
        modifier(
            ViewModifiers._Shadow(
                color: color, radius: radius, x: x, y: y
            )
        )
    }
}

extension ViewModifiers._Shadow: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Shadow"
        }

        let shadowView = ShadowView()

        func update(
            viewModifier: ViewModifiers._Shadow,
            context: inout Context
        ) {
            shadowView.layer.shadowColor = viewModifier.color.cgColor
            shadowView.layer.shadowRadius = viewModifier.radius
            shadowView.layer.shadowOffset = CGSize(
                width: viewModifier.x,
                height: viewModifier.y
            )
            shadowView.layer.shadowOpacity = 1
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            shadowView.frame = bounds.rect
            container.view.addSubview(shadowView)
            shadowView.replaceSubnodes {
                node.render(
                    in: container.replacingView(shadowView),
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

extension ViewModifiers._Shadow {
    class ShadowView: ContainerView {
        override func layoutSubviews() {
            super.layoutSubviews()
            let path = CGMutablePath()
            for sublayer in layer.sublayers ?? [] {
                var sublayerPath: CGPath?
                if let sublayer = sublayer as? CAShapeLayer {
                    sublayerPath = sublayer.path
                } else if let mask = sublayer.mask {
                    if let mask = mask as? CAShapeLayer {
                        sublayerPath = mask.path
                    } else {
                        sublayerPath = CGPath(rect: mask.frame, transform: nil)
                    }
                } else {
                    sublayerPath = CGPath(rect: sublayer.frame, transform: nil)
                }
                if let sublayerPath = sublayerPath {
                    path.addPath(sublayerPath)
                }
            }
            if path != layer.shadowPath {
                layer.shadowPath = path
            }
        }
    }
}

//
// Created by Mike on 7/31/21.
//

extension ViewModifiers {
    public struct _Frame: ViewModifier, Layout {

        internal let width: CGFloat?
        internal let height: CGFloat?
        internal let alignment: Alignment

        internal init(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) {
            self.width = width
            self.height = height
            self.alignment = alignment
        }

        internal func layoutAlgorithm(nodes: [LayoutNode], env: EnvironmentValues) -> LayoutAlgorithm {
            LayoutAlgorithms.Frame(frame: self, node: nodes.first!)
        }
    }
}

extension View {
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view’s width, height, or
    /// both. If you only specify one of the dimensions, the resulting view
    /// assumes this view’s sizing behavior in the other dimension.
    ///
    /// > Warning: ``Alignment``s other than ``Alignment/center`` are not
    ///   currently implemented.
    ///
    /// - Parameters:
    ///   - width: A fixed width for the resulting view. If `width` is `nil`,
    ///     the resulting view assumes this view’s sizing behavior.
    ///   - height: A fixed height for the resulting view. If `height` is `nil`,
    ///     the resulting view assumes this view’s sizing behavior.
    ///   - alignment: The alignment of this view inside the resulting view.
    ///     `alignment` applies if this view is smaller than the size given by
    ///     the resulting frame.
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are `non-nil`.
    public func frame(
        width: Double? = nil,
        height: Double? = nil,
        alignment: Alignment = .center
    ) -> ModifiedContent<Self, ViewModifiers._Frame> {
        modifier(
            ViewModifiers._Frame(
                width: width.cgFloat,
                height: height.cgFloat,
                alignment: alignment
            )
        )
    }
}

extension ViewModifiers._Frame: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "Frame"
        }

        var viewModifier: ViewModifiers._Frame!
        var environment: EnvironmentValues!

        func update(viewModifier: ViewModifiers._Frame, context: inout Context) {
            self.viewModifier = viewModifier
            self.environment = context.environment
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
            viewModifier.layoutAlgorithm(nodes: [node], env: environment)
                .layoutSize(fitting: proposedSize, pass: pass)
                .idealSize
        }

        func layout(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {
            let childSize = node.layoutSize(
                fitting: bounds.proposedSize,
                pass: pass
            )
            node.layout(
                in: container,
                bounds: bounds.update(
                    to: CGRect(
                        origin: CGPoint(x: bounds.rect.minX, y: bounds.rect.minY),
                        size: childSize
                    )
                ),
                pass: pass
            )
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

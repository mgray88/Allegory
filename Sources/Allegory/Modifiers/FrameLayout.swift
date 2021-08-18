//
// Created by Mike on 7/31/21.
//

extension View {
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view’s width, height, or
    /// both. If you only specify one of the dimensions, the resulting view
    /// assumes this view’s sizing behavior in the other dimension.
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
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> ModifiedContent<Self, _FrameLayout> {
        modifier(
            _FrameLayout(
                width: width,
                height: height,
                alignment: alignment
            )
        )
    }
}

public struct _FrameLayout {
    internal let width: CGFloat?
    internal let height: CGFloat?
    internal let alignment: Alignment

    @usableFromInline
    internal init(width: CGFloat?, height: CGFloat?, alignment: Alignment) {
        self.width = width
        self.height = height
        self.alignment = alignment
    }

    public typealias AnimatableData = EmptyAnimatableData
    public typealias Body = Never
}

extension _FrameLayout: Animatable {}
extension _FrameLayout: ViewModifier {}

extension _FrameLayout: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "Frame"
        }

        var frame: _FrameLayout!
        var environment: EnvironmentValues!
        var size: CGSize!

        func update(viewModifier: _FrameLayout, context: inout Context) {
            self.frame = viewModifier
            self.environment = context.environment
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
            var targetSize = proposedSize
            if let width = frame.width {
                targetSize.width = width
            }
            if let height = frame.height {
                targetSize.height = height
            }

            var viewSize = node.size(fitting: targetSize, pass: pass)
            if let width = frame.width {
                viewSize.width = width
            }
            if let height = frame.height {
                viewSize.height = height
            }

            self.size = viewSize
            return viewSize
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            node.render(
                in: container,
                bounds: size.aligned(in: bounds, frame.alignment),
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

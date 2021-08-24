//
// Created by Mike on 7/31/21.
//

public struct _OverlayModifier<Overlay: View>: ViewModifier {
    public let alignment: Alignment
    public let overlay: Overlay

    @inlinable
    public init(_ alignment: Alignment, _ overlay: Overlay) {
        self.alignment = alignment
        self.overlay = overlay
    }
}

extension View {
    @available(iOS, introduced: 10.0, deprecated: 100000.0, message: "Use `overlay(alignment:content:)` instead.")
    @inlinable
    @_disfavoredOverload
    public func overlay<Overlay>(
        _ overlay: Overlay,
        alignment: Alignment = .center
    ) -> ModifiedContent<Self, _OverlayModifier<Overlay>> where Overlay: View {
        modifier(_OverlayModifier(alignment, overlay))
    }
    /// Layers specified views in front of this view.
    ///
    /// When you provide multiple views, TOCUIKit stacks them.
    ///
    /// - Parameters:
    ///   - alignment: An alignment that you use to position the overlayed view.
    ///     The default is ``Alignment/center``.
    ///   - content: A view builder that produces views to layer in front of
    ///     this view. Multiple views provided by content are organized in to a
    ///     ``ZStack``.
    /// - Returns: A view that layers the specified content in front of the
    ///   view.
    @inlinable
    public func overlay<V>(
        alignment: Alignment = .center,
        content: () -> V
    ) -> ModifiedContent<Self, _OverlayModifier<V>> where V: View {
        modifier(_OverlayModifier(alignment, content()))
    }
}

extension _OverlayModifier: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Overlay"
        }

        private var overlay: _OverlayModifier<Overlay>!
        private var overlayNode: SomeUIKitNode!
        private var childSize: CGSize!

        func update(viewModifier: _OverlayModifier<Overlay>, context: inout Context) {
            self.overlay = viewModifier
            overlayNode = viewModifier.overlay.resolve(context: context, cachedNode: overlayNode)
        }

        func size(
            fitting proposedSize: ProposedSize,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) -> CGSize {
            childSize = node.size(fitting: proposedSize, pass: pass)
            return childSize
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            node.render(in: container, bounds: bounds, pass: pass)
            let overlaySize = overlayNode.size(
                fitting: ProposedSize(childSize), pass: pass
            )
            overlayNode.render(
                in: container,
                bounds: overlaySize.aligned(in: bounds, overlay.alignment),
                pass: pass
            )
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

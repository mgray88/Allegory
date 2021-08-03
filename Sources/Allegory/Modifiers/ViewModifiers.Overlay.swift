//
// Created by Mike on 7/31/21.
//

extension ViewModifiers {
    public struct _Overlay<Overlay: View>: ViewModifier {
        public let overlay: Overlay

        @inlinable
        public init(_ overlay: Overlay) {
            self.overlay = overlay
        }
    }
}

extension View {
    /// Layers specified views in front of this view.
    ///
    /// When you provide multiple views, TOCUIKit stacks them.
    ///
    /// > Warning: `alignment` not yet implemented.
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
        alignment: Alignment = .center, // TODO: overlay alignment
        content: () -> V
    ) -> ModifiedContent<Self, ViewModifiers._Overlay<V>> where V: View {
        modifier(ViewModifiers._Overlay(content()))
    }
}

extension ViewModifiers._Overlay: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Overlay"
        }

        private var overlayNode: SomeUIKitNode!

        func update(viewModifier: ViewModifiers._Overlay<Overlay>, context: inout Context) {
            overlayNode = viewModifier.overlay.resolve(context: context, cachedNode: overlayNode)
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            node.layout(in: container, bounds: bounds, pass: pass)
            overlayNode.layout(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

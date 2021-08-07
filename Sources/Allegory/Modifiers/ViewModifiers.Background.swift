//
// Created by Mike on 7/29/21.
//

extension ViewModifiers {
    public struct _Background<Background: View>: ViewModifier {
        public let background: Background

        @inlinable
        public init(background: Background) {
            self.background = background
        }
    }
}

extension View {
    /// Layers the given view behind this view.
    ///
    /// - Parameter background: The view to draw behind this view.
    @inlinable
    public func background<Background: View>(
        _ background: Background
    ) -> ModifiedContent<Self, ViewModifiers._Background<Background>> {
        modifier(.init(background: background))
    }

    @inlinable
    public func background<V: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> ModifiedContent<Self, ViewModifiers._Background<V>> {
        modifier(.init(background: content()))
    }
}

extension ViewModifiers._Background: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Background"
        }

        private var backgroundNode: SomeUIKitNode!

        func update(viewModifier: ViewModifiers._Background<Background>, context: inout Context) {
            backgroundNode = viewModifier.background.resolve(context: context, cachedNode: backgroundNode)
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            backgroundNode.layout(in: container, bounds: bounds, pass: pass)
            node.layout(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

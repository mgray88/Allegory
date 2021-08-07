//
// Created by Mike on 7/29/21.
//

/// A type-erased view.
///
/// An `AnyView` allows changing the type of view used in a given view
/// hierarchy. Whenever the type of view used with an `AnyView` changes, the old
/// hierarchy is destroyed and a new hierarchy is created for the new type.
public struct AnyView: View {
    public typealias Body = Swift.Never

    internal let view: SomeView

    /// Create an instance that type-erases `view`.
    public init<V>(_ view: V) where V: View {
        self.view = view
    }
}

extension AnyView: UIKitNodeResolvable {

    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "AnyView<\(node.hierarchyIdentifier)>"
        }

        var node: SomeUIKitNode!

        func update(view: AnyView, context: Context) {
            node = view.view.resolve(context: context, cachedNode: node)
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            node.layoutSize(fitting: proposedSize, pass: pass)
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            node.layout(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

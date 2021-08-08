//
// Created by Mike on 7/31/21.
//

internal enum VariadicView: View {

    internal typealias Body = Swift.Never

    internal struct Tree<Root: Layout, Content: View>: View {

        internal typealias Body = Swift.Never

        internal let root: Root
        internal let content: Content

        @inlinable
        internal init(root: Root, content: Content) {
            self.root = root
            self.content = content
        }

        @inlinable
        internal init(_ root: Root, @ViewBuilder content: () -> Content) {
            self.root = root
            self.content = content()
        }
    }
}

extension VariadicView.Tree: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Tree<\(nodes.map(\.hierarchyIdentifier).joined(separator: ", "))>"
        }

        var nodes: [SomeUIKitNode]!

        var layoutAlgorithm: LayoutAlgorithm!

        func update(view: SomeView, context: Context) {
            if let view = view as? VStack<Content> {
                self.nodes = view.tree.content.resolve(context: context, cachedNodes: nodes ?? [])
                self.layoutAlgorithm = view.tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else if let view = view as? HStack<Content> {
                self.nodes = view.tree.content.resolve(context: context, cachedNodes: nodes ?? [])
                self.layoutAlgorithm = view.tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else if let view = view as? ZStack<Content> {
                self.nodes = view.tree.content.resolve(context: context, cachedNodes: nodes ?? [])
                self.layoutAlgorithm = view.tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else {
                fatalError()
            }
        }

        func update(view: VariadicView.Tree<Root, Content>, context: Context) {
            fatalError()
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            layoutAlgorithm.size(
                fitting: proposedSize,
                pass: pass
            )
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            let layout = layoutAlgorithm.size(
                fitting: bounds.proposedSize,
                pass: pass
            )
            layoutAlgorithm.render(
                context: .init(container: container, bounds: bounds),
                size: bounds.size,
                pass: pass
            )
//            zip(nodes, layout.frames).forEach { node, frame in
//                node.render(
//                    in: container,
//                    bounds: Bounds(
//                        rect: frame.offsetBy(dx: bounds.origin.x, dy: bounds.origin.y),
//                        safeAreaInsets: .zero
//                    ),
//                    pass: pass
//                )
//            }
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

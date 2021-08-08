//
// Created by Mike on 7/31/21.
//

extension Optional: SomeView where Wrapped: SomeView {
    public var body: SomeView {
        fatalError()
    }
}

extension Optional: View where Wrapped: View {
    public typealias Body = Swift.Never
}

extension Optional: UIKitNodeResolvable where Wrapped: SomeView {
    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Optional<***>"
        }

        var node: SomeUIKitNode?

        func update(view: Optional, context: Context) {
            node = view.map { $0.resolve(context: context, cachedNode: node) }
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            node?.size(fitting: proposedSize, pass: pass) ?? .zero
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            node?.render(in: container, bounds: bounds, pass: pass)
        }

    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

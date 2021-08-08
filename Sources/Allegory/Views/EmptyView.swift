//
// Created by Mike on 7/29/21.
//

/// A view that doesn’t contain any content.
///
/// You will rarely, if ever, need to create an `EmptyView` directly. Instead,
/// `EmptyView` represents the absence of a view.
public struct EmptyView: View {
    public typealias Body = Never
}

extension EmptyView: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "EmptyView"
        }

        func update(view: EmptyView, context: Context) {}

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            .zero
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {}
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

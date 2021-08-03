//
// Created by Mike on 7/29/21.
//

protocol UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode
}

protocol TransientContainerView {
    var contentViews: [SomeView] { get }
}

extension SomeView {

    public var contentViews: [SomeView] {
        if let container = self as? TransientContainerView {
            return container.contentViews
        } else {
            return [self]
        }
    }

    internal func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        let resolvedNode: SomeUIKitNode
        if let view = self as? UIKitNodeResolvable {
            resolvedNode = view.resolve(context: context, cachedNode: cachedNode)
        } else if let view = self as? AnyUIViewRepresentable {
            let node = (cachedNode as? UIViewRepresentableNode) ?? UIViewRepresentableNode()
            node.update(view: view, context: context)
            return node
        } else {
            resolvedNode = cachedNode as? ViewNode ?? ViewNode()
        }
        resolvedNode.update(view: self, context: context)
        return resolvedNode
    }

    internal func resolve(context: Context, cachedNodes: [SomeUIKitNode]) -> [SomeUIKitNode] {
        let views = contentViews
        if views.count == cachedNodes.count {
            return zip(views, cachedNodes).map {
                $0.resolve(context: context, cachedNode: $1)
            }
        } else {
            return views.map {
                $0.resolve(context: context, cachedNode: nil)
            }
        }
    }
}

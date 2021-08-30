//
// Created by Mike on 7/31/21.
//

import Foundation

/// A View created from a swift tuple of View values.
public struct TupleView<T>: View {

    public typealias Body = Swift.Never

    public let value: T

    @inlinable
    public init(_ value: T) {
        self.value = value
    }
}

extension TupleView: _PrimitiveView {
    func buildNodeTree(_ node: Node) {
        let children = contentViews
        for idx in children.indices {
            if node.children.count <= idx {
                node.children.append(Node())
            }
            var child = children[idx]
            child.buildNodeTree(node.children[idx])
        }
    }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        TODO()
    }

    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        TODO()
    }
}

extension TupleView: TransientContainerView {
    var contentViews: [SomeView] {
        Mirror(reflecting: value).children.flatMap { ($0.value as! SomeView).contentViews }
    }
}

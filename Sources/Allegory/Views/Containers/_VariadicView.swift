//
// Created by Mike on 7/31/21.
//

public enum _VariadicView: View {
    public typealias Root = _VariadicView_Root
    public typealias ViewRoot = _VariadicView_ViewRoot
    public typealias Children = _VariadicView_Children
    public typealias UnaryViewRoot = _VariadicView_UnaryViewRoot
//    public typealias MultiViewRoot = _VariadicView_MultiViewRoot

    public typealias Body = Swift.Never

    public struct Tree<Root, Content> where Root: _VariadicView_Root {
        public var root: Root
        public var content: Content

        @_LayoutState
        internal var sizes: [CGSize] = []

        @inlinable
        internal init(root: Root, content: Content) {
            self.root = root
            self.content = content
        }

        @inlinable
        public init(_ root: Root, @ViewBuilder content: () -> Content) {
            self.root = root
            self.content = content()
        }
    }
}

@propertyWrapper
final class _LayoutState<A> {
    var wrappedValue: A
    init(wrappedValue: A) {
        self.wrappedValue = wrappedValue
    }
}

public protocol _VariadicView_Root {}

public protocol _VariadicView_ViewRoot: _VariadicView_Root {
    associatedtype Body: View
    @ViewBuilder func body(children: _VariadicView.Children) -> Self.Body
}

extension _VariadicView_ViewRoot where Self.Body == Never {
    public func body(children: _VariadicView.Children) -> Never {
        abstractMethod()
    }
}

public protocol _VariadicView_UnaryViewRoot: _VariadicView_ViewRoot {}

public struct _VariadicView_Children: View, SomeView {
    public typealias Body = Never
}

//extension _VariadicView_Children: RandomAccessCollection {
//    public struct Element : View, Identifiable {
//        public var body: Never
//
//        public var id: AnyHashable {
//            get {
//                fatalError()
//            }
//        }
//        public func id<ID>(as _: ID.Type = ID.self) -> ID? where ID : Hashable {
//            fatalError()
//        }
//        public subscript<Trait>(key: Trait.Type) -> Trait.Value where Trait : _ViewTraitKey {
//            get {
//                fatalError()
//            }
//            set {
//                fatalError()
//            }
//        }
//        public typealias ID = AnyHashable
//        public typealias Body = Never
//    }
//    public var startIndex: Int {
//        get {
//            fatalError()
//        }
//    }
//    public var endIndex: Int {
//        get {
//            fatalError()
//        }
//    }
//    public subscript(index: Int) -> _VariadicView_Children.Element {
//        get {
//            fatalError()
//        }
//    }
//    public typealias Index = Int
//    public typealias Iterator = IndexingIterator<_VariadicView_Children>
//    public typealias SubSequence = Slice<_VariadicView_Children>
//    public typealias Indices = Range<Int>
//}

extension _VariadicView.Tree: View, SomeView
    where Root: _VariadicView_ViewRoot, Content: View {

    public typealias Body = Never
}

extension _VariadicView.Tree: UIKitNodeResolvable
    where Root: _VariadicView_ViewRoot, Content: View {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Tree<\(nodes.map(\.hierarchyIdentifier).joined(separator: ", "))>"
        }

        var nodes: [SomeUIKitNode]!

        var size: ((ProposedSize, LayoutPass) -> CGSize)!
        var render: ((RenderingContext, Bounds) -> Void)!

        func update(view: SomeView, context: Context) {
            var context = context
            if let view = view as? VStack<Content> {
                context.environment._layoutAxis = .vertical
                let nodes = view._tree.content.resolve(
                    context: context,
                    cachedNodes: nodes ?? []
                )
                size = { size, pass in
                    view._tree.size(fitting: size, for: nodes)
                }
                render = { context, bounds in
                    view._tree.render(
                        context: context,
                        bounds: bounds,
                        nodes: nodes
                    )
                }
                self.nodes = nodes
            } else if let view = view as? HStack<Content> {
                context.environment._layoutAxis = .horizontal
                let nodes = view._tree.content.resolve(
                    context: context,
                    cachedNodes: nodes ?? []
                )
                size = { size, pass in
                    view._tree.size(fitting: size, for: nodes)
                }
                render = { context, bounds in
                    view._tree.render(
                        context: context,
                        bounds: bounds,
                        nodes: nodes
                    )
                }
                self.nodes = nodes
            } else if let view = view as? ZStack<Content> {
                nodes = view._tree.content.resolve(
                    context: context,
                    cachedNodes: nodes ?? []
                )
//                self.layoutAlgorithm = view._tree.root.layoutAlgorithm(nodes: nodes, env: context.environment)
            } else {
                fatalError()
            }
        }

        func update(view: _VariadicView.Tree<Root, Content>, context: Context) {
            fatalError()
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            size(proposedSize, pass)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            render(.init(container: container, bounds: bounds), bounds)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

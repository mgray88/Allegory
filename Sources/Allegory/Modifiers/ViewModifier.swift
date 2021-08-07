//
// Created by Mike on 7/29/21.
//

public protocol ViewModifier: SomeViewModifier {
    associatedtype Body: View
    typealias Content = ViewModifierContent<Self>
    func _body(content: Content) -> Body
    func body(content: Content) -> SomeView
}

extension ViewModifier {
    public func body(content: SomeView) -> SomeView {
        body(content: Content(content, modifier: self))
    }

    public func body(content: Content) -> SomeView {
        fatalError()
    }
}

extension ViewModifier where Body == Never {
    public func _body(content: Content) -> Never {
        fatalError()
    }
}

extension ViewModifier {
    /// Returns a new modifier that is the result of concatenating
    /// `self` with `modifier`.
    @inlinable
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

public struct ViewModifierContent<VM: SomeViewModifier>: View {
    public let view: SomeView
    public let modifier: VM

    public init(_ view: SomeView, modifier: VM) {
        self.view = view
        self.modifier = modifier
    }

    public var body: Never {
        fatalError()
    }
}

extension ViewModifierContent: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "ViewModifierContent<\(content.hierarchyIdentifier)>"
        }

        var content: SomeUIKitNode!

        func update(view: ViewModifierContent<VM>, context: Context) {
            content = view.view.resolve(context: context, cachedNode: content)
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            content.layoutSize(fitting: proposedSize, pass: pass)
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            content.layout(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

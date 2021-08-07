//
// Created by Mike on 7/29/21.
//

/// A value with a modifier applied to it.
public struct ModifiedContent<Content, Modifier> {

    public typealias Body = Swift.Never

    /// The content that the modifier transforms into a new view or new
    /// view modifier.
    public var content: Content

    /// The view modifier.
    public var modifier: Modifier

    /// A structure that the defines the content and modifier needed to produce
    /// a new view or view modifier.
    ///
    /// If `content` is a ``View`` and `modifier` is a ``ViewModifier``, the
    /// result is a ``View``. If `content` and `modifier` are both view
    /// modifiers, then the result is a new ``ViewModifier`` combining them.
    ///
    /// - Parameters:
    ///     - content: The content that the modifier changes.
    ///     - modifier: The modifier to apply to the content.
    @inlinable public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

extension ModifiedContent: View, SomeView
    where Content: View, Modifier: ViewModifier {

    public var body: ModifiedContent<Content, Modifier>.Body {
        fatalError("body has not been implemented")
    }
}

extension ModifiedContent: ViewModifier, SomeViewModifier
    where Content: ViewModifier, Modifier: ViewModifier {
}

extension ModifiedContent: Equatable
    where Content: Equatable, Modifier: Equatable {}

extension View {
    public func modifier<Modifier: ViewModifier>(
        _ modifier: Modifier
    ) -> ModifiedContent<Self, Modifier> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

extension ModifiedContent: UIKitNodeResolvable
    where Content: View, Modifier: ViewModifier {

    private class ViewNode: UIKitNode {
        var hierarchyIdentifier: String {
            "ModifiedContent<\(contentNode.hierarchyIdentifier), \(contentNodeModifier?.hierarchyIdentifier ?? "Never")>"
        }

        var contentNode: SomeUIKitNode!
        var contentNodeModifier: AnyUIKitNodeModifier?
        var layoutPriority: Double {
            if let layoutModifier = contentNodeModifier as? ViewModifiers._LayoutPriority.Node {
                return layoutModifier.layoutPriority
            } else {
                return contentNode.layoutPriority
            }
        }

        func update(view: ModifiedContent<Content, Modifier>, context: Context) {
            var context = context
            if let contentNodeModifier = view.modifier.resolve(context: &context, cachedNodeModifier: contentNodeModifier) {
                self.contentNodeModifier = contentNodeModifier
                contentNode = view.content.resolve(context: context, cachedNode: contentNode)
            } else {
                contentNode = view.modifier.body(content: view.content).resolve(context: context, cachedNode: contentNode)
            }
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            if let contentNodeModifier = contentNodeModifier {
                return contentNodeModifier.layoutSize(fitting: proposedSize, pass: pass, node: contentNode)
            } else {
                return contentNode.layoutSize(fitting: proposedSize, pass: pass)
            }
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            if let contentNodeModifier = contentNodeModifier {
                contentNodeModifier.layout(in: container, bounds: bounds, pass: pass, node: contentNode)
            } else {
                contentNode.layout(in: container, bounds: bounds, pass: pass)
            }
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? ViewNode) ?? ViewNode()
    }
}

extension ModifiedContent: UIKitNodeModifierResolvable
    where Content: ViewModifier, Modifier: ViewModifier {

    private class ModifierNode: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            ""
        }

        var viewModifier: ModifiedContent<Content, Modifier>!

        func update(
            viewModifier: ModifiedContent<Content, Modifier>,
            context: inout Context
        ) {
            self.viewModifier = viewModifier
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
            fatalError("layoutSize(fitting:pass:node:) has not been implemented")
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? ModifierNode) ?? ModifierNode()
    }
}

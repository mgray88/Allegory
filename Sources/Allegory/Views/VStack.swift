//
// Created by Mike on 7/31/21.
//

/// A view that arranges its children in a vertical line.
public struct VStack<Content: View>: View {

    public typealias Body = Swift.Never

    internal let tree: VariadicView.Tree<Layouts.VStack, Content>

    /// Creates an instance with the given spacing and horizontal alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack. This
    ///     guide has the same vertical screen coordinate for every child view.
    ///   - spacing: The distance between adjacent subviews, or `nil` if you
    ///     want the stack to choose a default distance for each pair of
    ///     subviews.
    ///   - content: A view builder that creates the content of this stack.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: Double? = nil,
        @ViewBuilder content: () -> Content
    ) {
        tree = .init(
            root: .init(
                alignment: alignment,
                spacing: spacing.cgFloat
            ),
            content: content()
        )
    }
}

extension VStack: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        tree.resolve(context: context, cachedNode: cachedNode)
    }
}

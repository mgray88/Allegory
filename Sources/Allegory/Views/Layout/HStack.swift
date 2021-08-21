//
// Created by Mike on 7/31/21.
//

/// A view that arranges its children in a horizontal line.
public struct HStack<Content: View>: View {

    public typealias Body = Swift.Never

    @usableFromInline
    internal let _tree: _VariadicView.Tree<_HStackLayout, Content>

    /// Creates a horizontal stack with the given spacing and vertical
    /// alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack. This
    ///     guide has the same vertical screen coordinate for every child view.
    ///   - spacing: The distance between adjacent subviews, or `nil` if you
    ///     want the stack to choose a default distance for each pair of
    ///     subviews.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable
    public init(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        _tree = .init(
            root: .init(
                alignment: alignment,
                spacing: spacing
            ),
            content: content()
        )
    }
}

public struct _HStackLayout {
    public let alignment: VerticalAlignment
    public let spacing: CGFloat?

    @inlinable
    public init(alignment: VerticalAlignment, spacing: CGFloat?) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public typealias Body = Swift.Never
}

extension _VariadicView.Tree where Root == _HStackLayout, Content: View {
    func size(
        fitting proposed: ProposedSize,
        for nodes: [SomeUIKitNode]
    ) -> CGSize {
        layout(fitting: proposed, for: nodes)
        let width: CGFloat = sizes.reduce(CGFloat(0)) { $0 + $1.width }
        let height: CGFloat = sizes.reduce(0) { max($0, $1.height) }
        return CGSize(width: width, height: height)
    }

    func render(
        context: RenderingContext,
        bounds: Bounds,
        nodes: [SomeUIKitNode]
    ) {
        let stackY = root.alignment.alignmentID.defaultValue(in: .init(bounds.size))
        var currentX: CGFloat = 0
        zip(nodes, sizes).forEach { child, childSize in
            let childY = root.alignment.alignmentID.defaultValue(in: .init(childSize))
            child.render(
                in: context.container,
                bounds: Bounds(
                    rect: CGRect(
                        origin: .init(x: currentX, y: stackY - childY),
                        size: childSize
                    ).offsetBy(dx: bounds.rect.minX, dy: bounds.rect.minY),
                    safeAreaInsets: .zero
                ),
                pass: LayoutPass()
            )
            currentX += childSize.width + (root.spacing ?? 0) // TODO: defaultSpacing
        }
    }

    func layout(
        fitting proposed: ProposedSize,
        for nodes: [SomeUIKitNode]
    ) {
        let flexibilities: [CGFloat] = nodes.map { child in
            let lower = child.size(
                fitting: ProposedSize(width: 0, height: proposed.height),
                pass: LayoutPass()
            ).width
            let upper = child.size(
                fitting: ProposedSize(width: .greatestFiniteMagnitude, height: proposed.height),
                pass: LayoutPass()
            ).width
            return upper - lower
        }
        // Order nodes by flexibility
        var remaining = nodes.indices.sorted { l, r in
            flexibilities[l] < flexibilities[r]
        }
        var remainingWidth = proposed.width ?? 0

        // subtract inter item spacing
        remainingWidth -= CGFloat(nodes.count - 1) * (root.spacing ?? 0) // TODO: default spacing
        var sizes: [CGSize] = Array(repeating: .zero, count: nodes.count)
        while !remaining.isEmpty {
            // We don't ever want to propose a negative width
            if remainingWidth < 0 { remainingWidth = 0 }

            let idx = remaining.removeFirst()
            let child = nodes[idx]

            let width: CGFloat
            if child.isSpacer {
                // Propose zero width and let spacer return minLength if set
                width = 0
            } else {
                width = remainingWidth / CGFloat(remaining.count + 1 )
            }

            let size = child.size(
                fitting: ProposedSize(width: width, height: proposed.height),
                pass: LayoutPass()
            )
            sizes[idx] = size
            remainingWidth -= size.width
        }

        // Distribute any remaining space among spacers in flexibility order
        if remainingWidth > 0 {
            var spacers = nodes.enumerated().filter { $0.element.isSpacer }
            while !spacers.isEmpty {
                if remainingWidth < 0 { break }
                let width: CGFloat = remainingWidth / CGFloat(spacers.count)
                let spacer = spacers.removeFirst()
                sizes[spacer.offset].width += width
                remainingWidth -= width
            }
        }

        self.sizes = sizes
    }
}

extension _HStackLayout: _VariadicView_ViewRoot {}

extension _HStackLayout: _VariadicView_UnaryViewRoot {}

extension HStack: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        _tree.resolve(context: context, cachedNode: cachedNode)
    }
}

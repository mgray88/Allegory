//
// Created by Mike on 7/31/21.
//

/// A view that arranges its children in a vertical line.
public struct VStack<Content: View>: View {

    public typealias Body = Swift.Never

    @usableFromInline
    internal let _tree: _VariadicView.Tree<_VStackLayout, Content>

    /// Creates an instance with the given spacing and horizontal alignment.
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
        alignment: HorizontalAlignment = .center,
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

public struct _VStackLayout {
    public let alignment: HorizontalAlignment
    public let spacing: CGFloat?

    @inlinable
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil
    ) {
        self.alignment = alignment
        self.spacing = spacing
    }

    public typealias Body = Swift.Never
}

extension _VariadicView.Tree where Root == _VStackLayout, Content: View {
    func size(
        fitting proposed: ProposedSize,
        for nodes: [SomeUIKitNode]
    ) -> CGSize {
        layout(fitting: proposed, for: nodes)
        let width: CGFloat = sizes.reduce(0) { max($0, $1.width) }
        let height: CGFloat = sizes.reduce(0) { $0 + $1.height }
        return CGSize(width: width, height: height)
    }

    func render(context: RenderingContext, bounds: Bounds, nodes: [SomeUIKitNode]) {
        let stackX = root.alignment.alignmentID.defaultValue(in: .init(bounds.size))
        var currentY: CGFloat = 0
        zip(nodes, sizes).forEach { child, childSize in
            let childX = root.alignment.alignmentID.defaultValue(in: .init(childSize))
            child.render(
                in: context.container,
                bounds: Bounds(
                    rect: CGRect(
                        origin: .init(x: stackX - childX, y: currentY),
                        size: childSize
                    ).offsetBy(dx: bounds.rect.minX, dy: bounds.rect.minY),
                    safeAreaInsets: .zero
                ),
                pass: LayoutPass()
            )
            currentY += childSize.height + (root.spacing ?? 0) // TODO: defaultSpacing
        }
    }

    func layout(
        fitting proposed: ProposedSize,
        for nodes: [SomeUIKitNode]
    ) {
        let flexibilities: [CGFloat] = nodes.map { child in
            let lower = child.size(
                fitting: ProposedSize(width: proposed.width, height: 0),
                pass: LayoutPass()
            ).height
            let upper = child.size(
                fitting: ProposedSize(width: proposed.width, height: .greatestFiniteMagnitude),
                pass: LayoutPass()
            ).height
            return upper - lower
        }
        var remaining = nodes.indices.sorted { l, r in
            flexibilities[l] < flexibilities[r]
        }
        var remainingHeight = proposed.height ?? 0

        // subtract inter item spacing
        remainingHeight -= CGFloat(nodes.count - 1) * (root.spacing ?? 0) // TODO: defaultSpacing
        var sizes: [CGSize] = Array(repeating: .zero, count: nodes.count)
        while !remaining.isEmpty {
            // We don't ever want to propose a negative height
            if remainingHeight < 0 { remainingHeight = 0 }

            let idx = remaining.removeFirst()
            let child = nodes[idx]

            let height: CGFloat
            if child.isSpacer {
                // Propose zero height and let spacer return minLength if set
                height = 0
            } else {
                height = remainingHeight / CGFloat(remaining.count + 1)
            }

            let size = child.size(
                fitting: ProposedSize(width: proposed.width, height: height),
                pass: LayoutPass()
            )
            sizes[idx] = size
            remainingHeight -= size.height
        }

        if remainingHeight > 0 {
            var spacers = nodes.enumerated().filter { $0.element.isSpacer }
            while !spacers.isEmpty {
                if remainingHeight < 0 { break }
                let height: CGFloat = remainingHeight / CGFloat(spacers.count)
                let spacer = spacers.removeFirst()
                sizes[spacer.offset].height += height
                remainingHeight -= height
            }
        }

        self.sizes = sizes
    }
}

extension _VStackLayout: _VariadicView_ViewRoot {}

extension _VStackLayout: _VariadicView_UnaryViewRoot {}

extension VStack: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        _tree.resolve(context: context, cachedNode: cachedNode)
    }
}

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
        let interItemSpacing = CGFloat(nodes.count - 1) * (root.spacing ?? 0) // TODO: default spacing
        let width: CGFloat = sizes.reduce(CGFloat(0)) { $0 + $1.width } + interItemSpacing
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
        let flexibilities: [LayoutInfo] = nodes.enumerated().map { index, child in
            let lower = child.size(
                fitting: ProposedSize(width: 0, height: proposed.height),
                pass: LayoutPass()
            ).width
            let upper = child.size(
                fitting: ProposedSize(width: .greatestFiniteMagnitude, height: proposed.height),
                pass: LayoutPass()
            ).width
            return LayoutInfo(
                min: lower,
                max: upper,
                idx: index,
                priority: child.layoutPriority
            )
        }.sorted()
        let groups = flexibilities.group(by: \.priority)
        var sizes: [CGSize] = Array(repeating: .zero, count: nodes.count)
        var remainingWidth = proposed.width ?? 0

        let allMinWidths = flexibilities.map(\.min).reduce(0, +)
        remainingWidth -= allMinWidths

        // subtract inter item spacing
        remainingWidth -= CGFloat(nodes.count - 1) * (root.spacing ?? 0) // TODO: default spacing

        for group in groups {
            remainingWidth += group.map(\.min).reduce(0, +)

            var remainingIndices = group.map(\.idx)
            while !remainingIndices.isEmpty {
                // We don't ever want to propose a negative width
                if remainingWidth < 0 { remainingWidth = 0 }

                let idx = remainingIndices.removeFirst()
                let child = nodes[idx]

                let width: CGFloat
                if child.isSpacer {
                    // Propose zero width and let spacer return minLength if set
                    width = 0
                } else {
                    width = remainingWidth / CGFloat(remainingIndices.count + 1 )
                }

                let size = child.size(
                    fitting: ProposedSize(width: width, height: proposed.height),
                    pass: LayoutPass()
                )
                sizes[idx] = size
                remainingWidth -= size.width
            }
        }

        guard remainingWidth > 0
        else {
            self.sizes = sizes
            return
        }

        for group in groups {
            while remainingWidth > 0 {
                var expandableInfos = group.filter {
                    sizes[$0.idx].width < $0.max && !nodes[$0.idx].isSpacer
                }
                guard expandableInfos.count > 0 else { break }
                var expansions = 0
                while !expandableInfos.isEmpty {
                    if remainingWidth < 0 { remainingWidth = 0 }
                    let layoutInfo = expandableInfos.removeFirst()
                    let child = nodes[layoutInfo.idx]

                    let expansion = remainingWidth / CGFloat(expandableInfos.count + 1)

                    let size = child.size(
                        fitting: ProposedSize(
                            width: sizes[layoutInfo.idx].width + expansion,
                            height: proposed.height
                        ),
                        pass: LayoutPass()
                    )
                    let expandedWidth = size.width - sizes[layoutInfo.idx].width
                    sizes[layoutInfo.idx] = size
                    remainingWidth -= expandedWidth
                    if expandedWidth > 0 {
                        expansions += 1
                    }
                }
                if expansions == 0 {
                    break
                }
            }
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

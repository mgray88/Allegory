//
// Created by Mike on 7/31/21.
//

/// A view that overlays its children, aligning them in both axes.
///
/// The `ZStack` assigns each successive child view a higher z-axis value than
/// the one before it, meaning later children appear “on top” of earlier ones.
///
/// The following example creates a `ZStack` of 100 x 100 point ``Rectangle``
/// views filled with one of six colors, offsetting each successive child view
/// by 10 points so they don’t completely overlap:
///
/// ```swift
/// let colors: [Color] =
///     [.red, .orange, .yellow, .green, .blue, .purple]
///
/// var body: some View {
///     ZStack {
///         ForEach(0..<colors.count) {
///             Rectangle()
///                 .fill(colors[$0])
///                 .frame(width: 100, height: 100)
///                 .offset(x: CGFloat($0) * 10.0,
///                         y: CGFloat($0) * 10.0)
///         }
///     }
/// }
/// ```
///
/// The `ZStack` uses an ``Alignment`` to set the x- and y-axis coordinates of
/// each child, defaulting to a center alignment. In the following example, the
/// `ZStack` uses a ``Alignment/bottomLeading`` alignment to lay out two
/// children, a red 100 x 50 point rectangle below, and a blue 50 x 100 point
/// rectangle on top. Because of the alignment value, both rectangles share a
/// bottom-left corner with the `ZStack` (in locales where left is the leading
/// side).
///
/// ```swift
/// var body: some View {
///     ZStack(alignment: .bottomLeading) {
///         Rectangle()
///             .fill(Color.red)
///             .frame(width: 100, height: 50)
///         Rectangle()
///             .fill(Color.blue)
///             .frame(width:50, height: 100)
///     }
///     .border(Color.green, width: 1)
/// }
/// ```
public struct ZStack<Content: View>: View {
    public typealias Body = Swift.Never

    @usableFromInline
    internal let _tree: _VariadicView.Tree<_ZStackLayout, Content>

    /// Creates an instance with the given alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack on both
    ///     the x- and y-axes.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable
    public init(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        _tree = .init(
            root: .init(
                alignment: alignment
            ),
            content: content()
        )
    }
}

public struct _ZStackLayout {
    public var alignment: Alignment

    @inlinable
    public init(alignment: Alignment = .center) {
        self.alignment = alignment
    }
}

extension _VariadicView.Tree where Root == _ZStackLayout, Content: View {
    func size(
        fitting proposed: ProposedSize,
        for nodes: [SomeUIKitNode]
    ) -> CGSize {
        layout(fitting: proposed, for: nodes)
        let width: CGFloat = sizes.reduce(0) { max($0, $1.width) }
        let height: CGFloat = sizes.reduce(0) { max($0, $1.height) }
        return CGSize(width: width, height: height)
    }

    func render(
        context: RenderingContext,
        bounds: Bounds,
        nodes: [SomeUIKitNode]
    ) {
        let stackAlignment = root.alignment.point(for: bounds.size)
        zip(nodes, sizes).forEach { child, childSize in
            let childAlignment = root.alignment.point(for: childSize)
            child.render(
                in: context.container,
                bounds: Bounds(
                    rect: CGRect(
                        origin: stackAlignment - childAlignment,
                        size: childSize
                    ).offsetBy(dx: bounds.rect.minX, dy: bounds.rect.minY),
                    safeAreaInsets: .zero
                ),
                pass: LayoutPass()
            )
        }
    }

    func layout(
        fitting proposed: ProposedSize,
        for nodes: [SomeUIKitNode]
    ) {
        sizes = nodes.map { child in
            child.size(fitting: proposed, pass: LayoutPass())
        }
    }
}

extension _ZStackLayout: _VariadicView_ViewRoot {}

extension _ZStackLayout: _VariadicView_UnaryViewRoot {}

extension ZStack: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        _tree.resolve(context: context, cachedNode: cachedNode)
    }
}

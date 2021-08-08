//
// Created by Mike on 7/31/21.
//

internal protocol LayoutNode {

    var isSpacer: Bool { get }
    var layoutPriority: Double { get }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize

    func alignment(
        for alignment: HorizontalAlignment,
        in size: CGSize
    ) -> CGFloat?

    func alignment(
        for alignment: VerticalAlignment,
        in size: CGSize
    ) -> CGFloat?
}

extension LayoutNode {
    internal func axisFlipped() -> LayoutNode {
        AxisFlippedLayoutNode(layoutNode: self)
    }
}

private struct AxisFlippedLayoutNode: LayoutNode {
    let layoutNode: LayoutNode

    var isSpacer: Bool {
        layoutNode.isSpacer
    }

    var layoutPriority: Double {
        layoutNode.layoutPriority
    }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        let size = layoutNode.size(
            fitting: proposedSize.flipped,
            pass: pass
        )
        return CGSize(width: size.height, height: size.width)
    }

    func alignment(
        for alignment: HorizontalAlignment,
        in size: CGSize
    ) -> CGFloat? {
        layoutNode.alignment(for: alignment, in: size)
    }

    func alignment(
        for alignment: VerticalAlignment,
        in size: CGSize
    ) -> CGFloat? {
        layoutNode.alignment(for: alignment, in: size)
    }
}

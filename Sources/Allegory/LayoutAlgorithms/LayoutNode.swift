//
// Created by Mike on 7/31/21.
//

internal protocol LayoutNode {

    var isSpacer: Bool { get }
    var layoutPriority: Double { get }

    func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize
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

    func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize {
        let targetSize = CGSize(width: targetSize.height, height: targetSize.width)
        let size = layoutNode.layoutSize(fitting: targetSize, pass: pass)
        return CGSize(width: size.height, height: size.width)
    }
}

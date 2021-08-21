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

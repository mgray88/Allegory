//
// Created by Mike on 7/31/21.
//

internal protocol LayoutAlgorithm {
    /// Calculate the layout size fitting `targetSize`.
    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize

    ///
    func render(context: RenderingContext, size: CGSize, pass: LayoutPass)
}

extension LayoutAlgorithm {
    func render(context: RenderingContext, size: CGSize, pass: LayoutPass) {
        abstractMethod()
    }
}

struct RenderingContext {
    let container: Container
    let bounds: Bounds
}

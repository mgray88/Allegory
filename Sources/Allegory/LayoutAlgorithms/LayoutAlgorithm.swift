//
// Created by Mike on 7/31/21.
//

internal protocol LayoutAlgorithm {

    /// Calculate the stack geometry fitting `targetSize`.
    func layoutSize(
        fitting proposedSize: ProposedSize,
        pass: LayoutPass
    ) -> ContentGeometry
}

struct RenderingContext {
    let container: Container
    let bounds: Bounds
}

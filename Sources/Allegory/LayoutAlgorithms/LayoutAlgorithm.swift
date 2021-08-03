//
// Created by Mike on 7/31/21.
//

internal protocol LayoutAlgorithm {

    /// Calculate the stack geometry fitting `targetSize`.
    func contentLayout(fittingSize targetSize: CGSize, pass: LayoutPass) -> ContentGeometry
}

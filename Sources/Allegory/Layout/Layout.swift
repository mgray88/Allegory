//
// Created by Mike on 7/31/21.
//

internal protocol Layout: Equatable {
    func layoutAlgorithm(nodes: [LayoutNode], env: EnvironmentValues) -> LayoutAlgorithm
}

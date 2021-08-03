//
// Created by Mike on 7/31/21.
//

extension Layouts {
    internal struct ZStack: Layout, Equatable {

        internal let alignment: Alignment

        internal init(alignment: Alignment = .center) {
            self.alignment = alignment
        }

        internal func layoutAlgorithm(nodes: [LayoutNode], env: EnvironmentValues) -> LayoutAlgorithm {
            LayoutAlgorithms.ZStack(nodes: nodes, layout: self)
        }
    }
}

//
// Created by Mike on 7/31/21.
//

extension Layouts {
    internal struct HStack: Layout, Equatable {

        internal let alignment: VerticalAlignment
        internal let spacing: CGFloat?

        @inlinable
        internal init(alignment: VerticalAlignment, spacing: CGFloat?) {
            self.alignment = alignment
            self.spacing = spacing
        }

        internal func layoutAlgorithm(nodes: [LayoutNode], env: EnvironmentValues) -> LayoutAlgorithm {
            LayoutAlgorithms.HStack(nodes: nodes, layout: self, defaultSpacing: env.hStackSpacing.cgFloat)
        }
    }
}

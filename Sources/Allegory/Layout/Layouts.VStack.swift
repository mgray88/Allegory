//
// Created by Mike on 7/31/21.
//

extension Layouts {
    internal struct VStack: Layout, Equatable {

        internal let alignment: HorizontalAlignment
        internal let spacing: CGFloat?

        @inlinable
        internal init(alignment: HorizontalAlignment, spacing: CGFloat?) {
            self.alignment = alignment
            self.spacing = spacing
        }

        internal func layoutAlgorithm(nodes: [LayoutNode], env: EnvironmentValues) -> LayoutAlgorithm {
            LayoutAlgorithms.VStack(
                nodes: nodes,
                layout: self,
                defaultSpacing: env.vStackSpacing.cgFloat
            )
        }
    }
}

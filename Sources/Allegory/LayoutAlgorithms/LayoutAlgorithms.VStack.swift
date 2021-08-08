//
// Created by Mike on 7/31/21.
//

extension LayoutAlgorithms {

    /// A VStack layout is just an HStack layout flipped in axis :)
    internal struct VStack: LayoutAlgorithm {

        private var hStackLayout: LayoutAlgorithms.HStack

        internal init(nodes: [LayoutNode], layout: Layouts.VStack, defaultSpacing: CGFloat) {
            hStackLayout = LayoutAlgorithms.HStack(
                nodes: nodes.map { $0.axisFlipped() },
                layout: .init(alignment: layout.alignment.flipped, spacing: layout.spacing),
                defaultSpacing: defaultSpacing
            )
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            hStackLayout.size(
                fitting: proposedSize.flipped,
                pass: pass
            )
            .flipped()
            .idealSize
        }
    }
}

private extension ContentGeometry {

    func flipped() -> ContentGeometry {
        .init(
            idealSize: CGSize(width: idealSize.height, height: idealSize.width),
            frames: frames.map {
                CGRect(x: $0.origin.y, y: $0.origin.x, width: $0.size.height, height: $0.size.width)
            }
        )
    }
}

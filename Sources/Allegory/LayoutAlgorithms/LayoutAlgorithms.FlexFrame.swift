//
// Created by Mike on 8/1/21.
//

extension LayoutAlgorithms {
    internal struct FlexFrame: LayoutAlgorithm {
        internal let modifier: ViewModifiers._FlexFrame

        /// Modified node
        internal let node: LayoutNode

        /// Screen scale
        internal let screenScale: CGFloat

        internal init(
            flexFrame: ViewModifiers._FlexFrame,
            node: LayoutNode,
            screenScale: CGFloat = 2
        ) {
            self.modifier = flexFrame
            self.node = node
            self.screenScale = screenScale
        }

        /// Calculate the stack geometry fitting `targetSize` and aligned by `alignment`.
        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            var proposedSize = ProposedSize(
                width: proposedSize.width ?? modifier.idealWidth,
                height: proposedSize.height ?? modifier.idealHeight
            ).orDefault

            if let minWidth = modifier.minWidth, minWidth > proposedSize.width {
                proposedSize.width = minWidth
            }
            if let maxWidth = modifier.maxWidth, maxWidth < proposedSize.width {
                proposedSize.width = maxWidth
            }
            if let minHeight = modifier.minHeight, minHeight > proposedSize.height {
                proposedSize.height = minHeight
            }
            if let maxHeight = modifier.maxHeight, maxHeight < proposedSize.height {
                proposedSize.height = maxHeight
            }

            var size = node.size(fitting: ProposedSize(proposedSize), pass: pass)
            size.width = clamp(
                proposedSize.width,
                min: modifier.minWidth ?? size.width,
                max: modifier.maxWidth ?? size.width
            )
            size.height = clamp(
                proposedSize.height,
                min: modifier.minHeight ?? size.height,
                max: modifier.maxHeight ?? size.height
            )

            return size
        }
    }
}

private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    Swift.min(Swift.max(value, min), max)
}

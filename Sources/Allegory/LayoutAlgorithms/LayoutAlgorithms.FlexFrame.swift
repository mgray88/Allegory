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
        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> ContentGeometry {
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

            var size = node.layoutSize(fitting: ProposedSize(proposedSize), pass: pass)
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

            let rect: CGRect

            switch modifier.alignment {
            case .center:
                rect = CGRect(
                    x: (proposedSize.width - size.width) / 2,
                    y: (proposedSize.height - size.height) / 2,
                    width: size.width,
                    height: size.height
                )

            case .leading:
                rect = CGRect(
                    x: 0,
                    y: (proposedSize.height - size.height) / 2,
                    width: size.width,
                    height: size.height
                )

            default:
                TODO()
            }

            return ContentGeometry(idealSize: proposedSize, frames: [rect])
        }
    }
}

private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    Swift.min(Swift.max(value, min), max)
}

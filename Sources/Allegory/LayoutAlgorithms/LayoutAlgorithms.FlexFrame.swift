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
        internal func contentLayout(
            fittingSize targetSize: CGSize,
            pass: LayoutPass
        ) -> ContentGeometry {
            var idealSize = targetSize

            if let minWidth = modifier.minWidth {
                idealSize.width = max(idealSize.width, minWidth)
            }
            if let maxWidth = modifier.maxWidth {
                idealSize.width = min(idealSize.width, maxWidth)
            }
            if let minHeight = modifier.minHeight {
                idealSize.height = max(idealSize.height, minHeight)
            }
            if let maxHeight = modifier.maxHeight {
                idealSize.height = min(idealSize.height, maxHeight)
            }

            var size = node.layoutSize(fitting: idealSize, pass: pass)
            size.width = clamp(idealSize.width, min: modifier.minWidth ?? size.width, max: modifier.maxWidth ?? size.width)
            size.height = clamp(idealSize.height, min: modifier.minHeight ?? size.height, max: modifier.maxHeight ?? size.height)

            let rect: CGRect

            switch modifier.alignment {
            case .center:
                rect = CGRect(
                    x: (idealSize.width - size.width) / 2,
                    y: (idealSize.height - size.height) / 2,
                    width: size.width,
                    height: size.height
                )

            case .leading:
                rect = CGRect(
                    x: 0,
                    y: (idealSize.height - size.height) / 2,
                    width: size.width,
                    height: size.height
                )

            default:
                fatalError("TODO")
            }

            return ContentGeometry(idealSize: idealSize, frames: [rect])
        }
    }
}

private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    Swift.min(Swift.max(value, min), max)
}

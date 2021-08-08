//
// Created by Mike on 7/31/21.
//

extension LayoutAlgorithms {

    internal struct Frame: LayoutAlgorithm {

        internal let frame: ViewModifiers._Frame

        /// Modified node
        internal let node: LayoutNode

        /// Screen scale
        internal let screenScale: CGFloat

        internal init(
            frame: ViewModifiers._Frame,
            node: LayoutNode,
            screenScale: CGFloat = 2
        ) {
            self.frame = frame
            self.node = node
            self.screenScale = screenScale
        }

        /// Calculate the stack geometry fitting `targetSize` and aligned by `alignment`.
        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            if let width = frame.width,
               let height = frame.height {
                return CGSize(width: width, height: height)
            }

            var targetSize = proposedSize
            if let width = frame.width {
                targetSize.width = width
            }
            if let height = frame.height {
                targetSize.height = height
            }

            var viewSize = node.size(fitting: targetSize, pass: pass)
            if let width = frame.width {
                viewSize.width = width
            }
            if let height = frame.height {
                viewSize.height = height
            }

            return viewSize
        }
    }
}

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

        internal init(frame: ViewModifiers._Frame, node: LayoutNode, screenScale: CGFloat = 2) {
            self.frame = frame
            self.node = node
            self.screenScale = screenScale
        }

        /// Calculate the stack geometry fitting `targetSize` and aligned by `alignment`.
        internal func contentLayout(fittingSize targetSize: CGSize, pass: LayoutPass) -> ContentGeometry {
            var targetSize = targetSize
            if let width = frame.width {
                targetSize.width = min(targetSize.width, width)
            }
            if let height = frame.height {
                targetSize.height = min(targetSize.height, height)
            }

            var viewSize = node.layoutSize(fitting: targetSize, pass: pass)

            let selfPoint = frame.alignment.point(for: targetSize)
            let childPoint = frame.alignment.point(for: viewSize)

//            let rect: CGRect = CGRect(
//                x: selfPoint.x - childPoint.x,
//                y: selfPoint.y - childPoint.y,
//                width: viewSize.width,
//                height: viewSize.height
//            )
            let rect: CGRect
            switch frame.alignment {
            case .center:
                rect = CGRect(
                    x: (targetSize.width - viewSize.width) / 2,
                    y: (targetSize.height - viewSize.height) / 2,
                    width: viewSize.width,
                    height: viewSize.height
                )

            default:
                TODO()
            }

            return ContentGeometry(idealSize: rect.size, frames: [rect])
        }
    }
}

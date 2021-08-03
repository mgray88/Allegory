//
// Created by Mike on 7/31/21.
//

extension LayoutAlgorithms {
    internal class ZStack: LayoutAlgorithm {
        internal let nodes: [LayoutNode]
        internal let layout: Layouts.ZStack

        private var cache = GeometryCache()

        internal init(nodes: [LayoutNode], layout: Layouts.ZStack) {
            self.nodes = nodes
            self.layout = layout
        }

        /// Calculate the stack geometry fitting `targetSize`.
        internal func contentLayout(fittingSize targetSize: CGSize, pass: LayoutPass) -> ContentGeometry {
            if let geometry = cache.geometry(for: pass, size: targetSize) {
                return geometry
            }

            var idealSize: CGSize = .zero
            let frames = nodes.map { (node) -> CGRect in
                let size = node.layoutSize(fitting: targetSize, pass: pass)
                var alignedBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)

                switch layout.alignment.horizontal {
                case .leading:
                    alignedBounds.origin.x = 0

                case .center:
                    alignedBounds.origin.x = (targetSize.width - size.width) / 2

                case .trailing:
                    alignedBounds.origin.x = targetSize.width - size.width

                default:
                    notSupported()
                }

                switch layout.alignment.vertical {
                case .top:
                    alignedBounds.origin.y = 0

                case .center:
                    alignedBounds.origin.y = (targetSize.height - size.height) / 2

                case .bottom:
                    alignedBounds.origin.y = targetSize.height - size.height

                case .firstTextBaseline, .lastTextBaseline:
                    notSupported()

                default:
                    notSupported()
                }
                idealSize = CGSize(width: max(idealSize.width, size.width), height: max(idealSize.height, size.height))
                return alignedBounds
            }

            let geometry = ContentGeometry(idealSize: idealSize, frames: frames)
            cache.update(pass: pass, size: targetSize, geometry: geometry)
            return geometry
        }
    }
}

//
// Created by Mike on 7/31/21.
//

extension LayoutAlgorithms {

    internal class Padding: LayoutAlgorithm {

        internal let padding: ViewModifiers._Padding

        /// Modified node
        internal let node: LayoutNode

        /// Screen scale
        internal let screenScale: CGFloat

        private let defaultPadding: Double

        private var cache = GeometryCache()

        internal init(
            padding: ViewModifiers._Padding,
            node: LayoutNode,
            defaultPadding: Double,
            screenScale: CGFloat = 2
        ) {
            self.padding = padding
            self.node = node
            self.screenScale = screenScale
            self.defaultPadding = defaultPadding
        }

        /// Calculate the stack geometry fitting `targetSize` and aligned by `alignment`.
        internal func contentLayout(
            fittingSize targetSize: CGSize,
            pass: LayoutPass
        ) -> ContentGeometry {

            if let geometry = cache.geometry(for: pass, size: targetSize) {
                return geometry
            }

            let insets = EdgeInsets(
                top: padding.top ?? defaultPadding,
                leading: padding.leading ?? defaultPadding,
                bottom: padding.bottom ?? defaultPadding,
                trailing: padding.trailing ?? defaultPadding
            )

            let rect = CGRect(
                x: CGFloat(insets.leading),
                y: CGFloat(insets.top),
                width: targetSize.width - CGFloat(insets.leading + insets.trailing),
                height: targetSize.height - CGFloat(insets.top + insets.bottom)
            )

            let nodeSize = node.layoutSize(fitting: rect.size, pass: pass)

            let idealSize = CGSize(
                width: nodeSize.width + CGFloat(insets.leading + insets.trailing),
                height: nodeSize.height + CGFloat(insets.top + insets.bottom)
            )

            let geometry = ContentGeometry(idealSize: idealSize, frames: [rect])
            cache.update(pass: pass, size: targetSize, geometry: geometry)
            return geometry
        }
    }
}

//
// Created by Mike on 8/28/21.
//

import UIKit

@_spi(Internal)
open class HostingScrollView: UIScrollView, ContainerNode {
    open override class var layerClass: AnyClass {
        ContainerLayer.self
    }

    private var subviewsToRemove: Set<UIView> = []

    open override func addSubview(_ view: UIView) {
        subviewsToRemove.remove(view)
        super.addSubview(view)
    }

    public func replaceSubnodes(_ block: () -> Void) {
        subviewsToRemove = Set(subviews)
        (layer as! ContainerLayer).replaceSubnodes(block)
        subviewsToRemove.forEach { $0.removeFromSuperview() }
    }
}

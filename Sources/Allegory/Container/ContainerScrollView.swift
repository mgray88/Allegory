//
// Created by Mike on 8/1/21.
//

import UIKit

open class ContainerScrollView: UIScrollView, ContainerNode {
    open override class var layerClass: AnyClass {
        return ContainerLayer.self
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

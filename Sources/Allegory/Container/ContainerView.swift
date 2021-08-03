//
// Created by Mike on 7/29/21.
//

import UIKit

open class ContainerView: UIView, ContainerNode {

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

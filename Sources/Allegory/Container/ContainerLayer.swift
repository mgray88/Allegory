//
// Created by Mike on 7/29/21.
//

import UIKit

public let kMockingbirdLayerName = "kMockableLayer"

public final class ContainerLayer: CALayer, ContainerNode {

    private var sublayersToRemove: Set<CALayer> = []

    public override func addSublayer(_ layer: CALayer) {
        if layer.name == kMockingbirdLayerName {
            sublayersToRemove.remove(layer)
        }
        super.addSublayer(layer)
    }

    public func replaceSubnodes(_ block: () -> Void) {
        sublayersToRemove = Set(sublayers?.filter { $0.name == kMockingbirdLayerName } ?? [])
        block()
        sublayersToRemove.forEach { $0.removeFromSuperlayer() }
    }
}

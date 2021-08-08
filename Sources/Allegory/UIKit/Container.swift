//
// Created by Mike on 7/29/21.
//

import QuartzCore
import UIKit

public struct Container {

    public var view: UIView & ContainerNode

    @inlinable
    public var viewController: UIViewController? {
        view.parentViewController
    }

    @inlinable
    public var layer: CALayer & ContainerNode {
        view.layer as! CALayer & ContainerNode
    }

    func replacingView(_ view: UIView & ContainerNode) -> Container {
        var copy = self
        copy.view = view
        return copy
    }
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        next as? UIViewController ?? next?.parentViewController
    }
}

//
// Created by Mike on 8/3/21.
//

import UIKit

internal protocol ResolvableGesture {
    func resolve(cachedGestureRecognizer: UIGestureRecognizer?) -> GestureController
}

internal protocol GestureController: AnyObject {
    var _gestureRecognizer: UIGestureRecognizer { get }
    func registerEndAction<T>(_ action: T)
}

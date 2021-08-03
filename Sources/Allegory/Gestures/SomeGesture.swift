//
// Created by Mike on 8/3/21.
//

import UIKit.UIGestureRecognizer

public protocol SomeGesture {}

extension SomeGesture {
    func resolve(
        cachedGestureRecognizer: UIGestureRecognizer?
    ) -> GestureController {
        (self as! ResolvableGesture)
            .resolve(cachedGestureRecognizer: cachedGestureRecognizer)
    }
}

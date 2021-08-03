//
// Created by Mike on 8/3/21.
//

import UIKit.UIGestureRecognizer

public struct _EndedGesture<G: Gesture>: Gesture {

    public typealias Value = G.Value

    public let gesture: G
    public let action: (Value) -> Void

    @inlinable
    public init(_ gesture: G, action: @escaping (Value) -> Void) {
        self.gesture = gesture
        self.action = action
    }
}

extension _EndedGesture: ResolvableGesture where G: ResolvableGesture {
    func resolve(
        cachedGestureRecognizer: UIGestureRecognizer?
    ) -> GestureController {
        let controller = gesture.resolve(
            cachedGestureRecognizer: cachedGestureRecognizer
        )
        controller.registerEndAction(action)
        return controller
    }
}

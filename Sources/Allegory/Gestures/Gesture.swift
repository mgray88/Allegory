//
// Created by Mike on 8/3/21.
//

import UIKit.UIGestureRecognizer

/// An instance that matches a sequence of events to a gesture, and returns a
/// stream of values for each of its states.
///
/// Create custom gestures by declaring types that conform to the `Gesture`
/// protocol.
public protocol Gesture: SomeGesture {

    /// The type of value produced by this gesture.
    associatedtype Value
}

extension Gesture {
    /// Adds an action to perform when the gesture ends.
    ///
    /// - Parameter action: The action to perform when this gesture ends. The
    ///   `action` closure's parameter contains the final value of the gesture.
    ///
    /// - Returns: A gesture that triggers `action` when the gesture ends.
    @inlinable
    public func onEnded(
        _ action: @escaping (Self.Value) -> Void
    ) -> _EndedGesture<Self> {
        _EndedGesture(self, action: action)
    }
}

public struct AnyGesture<Value>: Gesture {

    internal let gesture: SomeGesture

    /// Creates an instance from another gesture.
    ///
    /// - Parameter gesture: A gesture that you use to create a new gesture.
    public init<T>(_ gesture: T) where Value == T.Value, T : Gesture {
        self.gesture = gesture
    }
}

extension AnyGesture: ResolvableGesture {
    func resolve(
        cachedGestureRecognizer: UIGestureRecognizer?
    ) -> GestureController {
        gesture.resolve(cachedGestureRecognizer: cachedGestureRecognizer)
    }
}

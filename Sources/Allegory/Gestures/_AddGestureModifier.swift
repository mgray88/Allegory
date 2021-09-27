//
//  Created by Mike on 9/18/21.
//

public struct _AddGestureModifier<G: Gesture>: ViewModifier {
    public enum Priority {
        case low
        case high
        case simultaneous
    }

    public let gesture: G
    public let priority: Priority

    @inlinable
    public init(_ gesture: G, priority: Priority) {
        self.gesture = gesture
        self.priority = priority
    }
}

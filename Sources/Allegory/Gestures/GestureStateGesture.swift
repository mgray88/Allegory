//
//  Created by Mike on 9/18/21.
//

/// TODO
public struct GestureStateGesture<Base, State>: Gesture where Base: Gesture {
    public typealias Value = Base.Value
    public var base: Base
    public var state: GestureState<State>
    public var body: (
        GestureStateGesture<Base, State>.Value,
        inout State,
        inout Transaction
    ) -> Void

    @inlinable
    public init(
        base: Base,
        state: GestureState<State>,
        body: @escaping (
            GestureStateGesture<Base, State>.Value,
            inout State,
            inout Transaction
        ) -> Void
    ) {
        self.base = base
        self.state = state
        self.body = body
    }

    public typealias Body = Never
}

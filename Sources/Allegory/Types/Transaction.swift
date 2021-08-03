//
// Created by Mike on 7/29/21.
//

public struct Transaction {

    public init() {}

    @inlinable
    public init(animation: Animation?) {
        self.animation = animation
    }

    public var animation: Animation?

    public var disablesAnimations: Bool = false
}

//
// Created by Mike on 8/14/21.
//

public class AnimationBoxBase: Equatable {
    public struct _Resolved {
        public var duration: Double {
            switch style {
            case let .timingCurve(_, _, _, _, duration):
                return duration
            case let .solver(solver):
                return solver.restingPoint(precision: 0.01)
            }
        }

        public var delay: Double
        public var speed: Double
        public var repeatStyle: _RepeatStyle
        public var style: _Style

        public enum _Style: Equatable {
            case timingCurve(Double, Double, Double, Double, duration: Double)
            case solver(_AnimationSolver)

            public static func == (lhs: Self, rhs: Self) -> Bool {
                switch lhs {
                case let .timingCurve(lhs0, lhs1, lhs2, lhs3, lhsDuration):
                    if case let .timingCurve(rhs0, rhs1, rhs2, rhs3, rhsDuration) = rhs {
                        return lhs0 == rhs0
                            && lhs1 == rhs1
                            && lhs2 == rhs2
                            && lhs3 == rhs3
                            && lhsDuration == rhsDuration
                    }
                case let .solver(lhsSolver):
                    if case let .solver(rhsSolver) = rhs {
                        return type(of: lhsSolver) == type(of: rhsSolver)
                    }
                }
                return false
            }
        }

        public enum _RepeatStyle: Equatable {
            case fixed(Int, autoreverses: Bool)
            case forever(autoreverses: Bool)

            public var autoreverses: Bool {
                switch self {
                case let .fixed(_, autoreverses),
                     let .forever(autoreverses):
                    return autoreverses
                }
            }
        }
    }

    func resolve() -> _Resolved {
        fatalError("implement \(#function) in subclass")
    }

    func equals(_ other: AnimationBoxBase) -> Bool {
        fatalError("implement \(#function) in subclass")
    }

    public static func == (lhs: AnimationBoxBase, rhs: AnimationBoxBase) -> Bool {
        lhs.equals(rhs)
    }
}

final class StyleAnimationBox: AnimationBoxBase {
    let style: _Resolved._Style

    init(style: _Resolved._Style) {
        self.style = style
    }

    override func resolve() -> AnimationBoxBase._Resolved {
        .init(delay: 0, speed: 1, repeatStyle: .fixed(1, autoreverses: true), style: style)
    }

    override func equals(_ other: AnimationBoxBase) -> Bool {
        guard let other = other as? StyleAnimationBox else { return false }
        return style == other.style
    }
}

final class DelayedAnimationBox: AnimationBoxBase {
    let delay: Double
    let parent: AnimationBoxBase

    init(delay: Double, parent: AnimationBoxBase) {
        self.delay = delay
        self.parent = parent
    }

    override func resolve() -> AnimationBoxBase._Resolved {
        var resolved = parent.resolve()
        resolved.delay = delay
        return resolved
    }

    override func equals(_ other: AnimationBoxBase) -> Bool {
        guard let other = other as? DelayedAnimationBox else { return false }
        return delay == other.delay && parent.equals(other.parent)
    }
}

final class RetimedAnimationBox: AnimationBoxBase {
    let speed: Double
    let parent: AnimationBoxBase

    init(speed: Double, parent: AnimationBoxBase) {
        self.speed = speed
        self.parent = parent
    }

    override func resolve() -> AnimationBoxBase._Resolved {
        var resolved = parent.resolve()
        resolved.speed = speed
        return resolved
    }

    override func equals(_ other: AnimationBoxBase) -> Bool {
        guard let other = other as? RetimedAnimationBox else { return false }
        return speed == other.speed && parent.equals(other.parent)
    }
}

final class RepeatedAnimationBox: AnimationBoxBase {
    let style: AnimationBoxBase._Resolved._RepeatStyle
    let parent: AnimationBoxBase

    init(style: AnimationBoxBase._Resolved._RepeatStyle, parent: AnimationBoxBase) {
        self.style = style
        self.parent = parent
    }

    override func resolve() -> AnimationBoxBase._Resolved {
        var resolved = parent.resolve()
        resolved.repeatStyle = style
        return resolved
    }

    override func equals(_ other: AnimationBoxBase) -> Bool {
        guard let other = other as? RepeatedAnimationBox else { return false }
        return style == other.style && parent.equals(other.parent)
    }
}

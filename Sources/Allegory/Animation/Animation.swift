//
// Created by Mike on 8/14/21.
//

extension View {

    /// Applies the given animation to this view when the specified value
    /// changes.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply. If `animation` is `nil`, the view
    ///     doesn't animate.
    ///   - value: A value to monitor for changes.
    ///
    /// - Returns: A view that applies `animation` to this view whenever `value`
    ///   changes.
    @inlinable
    public func animation<V>(
        _ animation: Animation?,
        value: V
    ) -> ModifiedContent<Self, _AnimationModifier<V>> where V: Equatable {
        modifier(_AnimationModifier(animation: animation, value: value))
    }
}

extension View where Self: Equatable {

    /// Applies the given animation to this view when this view changes.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply. If `animation` is `nil`, the view
    ///     doesn't animate.
    ///
    /// - Returns: A view that applies `animation` to this view whenever it
    ///   changes.
    @inlinable
    public func animation(
        _ animation: Animation?
    ) -> _AnimationView<Self> {
        _AnimationView(content: self, animation: animation)
    }
}

/// This default is specified in SwiftUI on `Animation.timingCurve` as `0.35`.
public let defaultDuration = 0.35

public struct Animation: Equatable {
    fileprivate var box: AnimationBoxBase

    private init(_ box: AnimationBoxBase) {
        self.box = box
    }

    public static let `default` = Self.easeInOut

    public func delay(_ delay: Double) -> Animation {
        .init(DelayedAnimationBox(delay: delay, parent: box))
    }

    /// Returns an animation that has its speed multiplied by `speed`. For
    /// example, if you had `oneSecondAnimation.speed(0.25)`, it would be at 25%
    /// of its normal speed, so you would have an animation that would last 4
    /// seconds.
    public func speed(_ speed: Double) -> Animation {
        .init(RetimedAnimationBox(speed: speed, parent: box))
    }

    public func repeatCount(
        _ repeatCount: Int,
        autoreverses: Bool = true
    ) -> Animation {
        .init(RepeatedAnimationBox(style: .fixed(repeatCount, autoreverses: autoreverses), parent: box))
    }

    public func repeatForever(autoreverses: Bool = true) -> Animation {
        .init(RepeatedAnimationBox(style: .forever(autoreverses: autoreverses), parent: box))
    }

    /// A persistent spring animation. When mixed with other `spring()`
    /// or `interactiveSpring()` animations on the same property, each
    /// animation will be replaced by their successor, preserving
    /// velocity from one animation to the next. Optionally blends the
    /// response values between springs over a time period.
    ///
    /// - Parameters:
    ///   - response: The stiffness of the spring, defined as an
    ///     approximate duration in seconds. A value of zero requests
    ///     an infinitely-stiff spring, suitable for driving
    ///     interactive animations.
    ///   - dampingFraction: The amount of drag applied to the value
    ///     being animated, as a fraction of an estimate of amount
    ///     needed to produce critical damping.
    ///   - blendDuration: The duration in seconds over which to
    ///     interpolate changes to the response value of the spring.
    /// - Returns: a spring animation.
    public static func spring(
        response: Double = 0.55,
        dampingFraction: Double = 0.825,
        blendDuration: Double = 0
    ) -> Animation {
        if response == 0 { // Infinitely stiff spring
            // (well, not .infinity, but a very high number)
            return interpolatingSpring(stiffness: 999, damping: 999)
        } else {
            return interpolatingSpring(
                mass: 1,
                stiffness: pow(2 * .pi / response, 2),
                damping: 4 * .pi * dampingFraction / response
            )
        }
    }

    /// A convenience for a `spring()` animation with a lower
    /// `response` value, intended for driving interactive animations.
    public static func interactiveSpring(
        response: Double = 0.15,
        dampingFraction: Double = 0.86,
        blendDuration: Double = 0.25
    ) -> Animation {
        spring(
            response: response,
            dampingFraction: dampingFraction,
            blendDuration: blendDuration
        )
    }

    /// An interpolating spring animation that uses a damped spring
    /// model to produce values in the range [0, 1] that are then used
    /// to interpolate within the [from, to] range of the animated
    /// property. Preserves velocity across overlapping animations by
    /// adding the effects of each animation.
    ///
    /// - Parameters:
    ///   - mass: The mass of the object attached to the spring.
    ///   - stiffness: The stiffness of the spring.
    ///   - damping: The spring damping value.
    ///   - initialVelocity: the initial velocity of the spring, as
    ///     a value in the range [0, 1] representing the magnitude of
    ///     the value being animated.
    /// - Returns: a spring animation.
    public static func interpolatingSpring(
        mass: Double = 1.0,
        stiffness: Double,
        damping: Double,
        initialVelocity: Double = 0.0
    ) -> Animation {
        .init(StyleAnimationBox(style: .solver(_AnimationSolvers.Spring(
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity
        ))))
    }

    public static func easeInOut(duration: Double) -> Animation {
        timingCurve(0.42, 0, 0.58, 1.0, duration: duration)
    }

    public static var easeInOut: Animation {
        easeInOut(duration: defaultDuration)
    }

    public static func easeIn(duration: Double) -> Animation {
        timingCurve(0.42, 0, 1.0, 1.0, duration: duration)
    }

    public static var easeIn: Animation {
        easeIn(duration: defaultDuration)
    }

    public static func easeOut(duration: Double) -> Animation {
        timingCurve(0, 0, 0.58, 1.0, duration: duration)
    }

    public static var easeOut: Animation {
        easeOut(duration: defaultDuration)
    }

    public static func linear(duration: Double) -> Animation {
        timingCurve(0, 0, 1, 1, duration: duration)
    }

    public static var linear: Animation {
        timingCurve(0, 0, 1, 1)
    }

    public static func timingCurve(
        _ c0x: Double,
        _ c0y: Double,
        _ c1x: Double,
        _ c1y: Double,
        duration: Double = defaultDuration
    ) -> Animation {
        .init(StyleAnimationBox(style: .timingCurve(c0x, c0y, c1x, c1y, duration: duration)))
    }
}

@frozen public struct _AnimationModifier<Value>: ViewModifier, Equatable
    where Value: Equatable {

    public let animation: Animation?
    public let value: Value

    @inlinable
    public init(animation: Animation?, value: Value) {
        self.animation = animation
        self.value = value
    }

    private struct ContentWrapper: View, Equatable {
        let content: Content
        let animation: Animation?
        let value: Value
        @State private var lastValue: Value?

        var body: SomeView {
            content.transaction {
                if lastValue != value {
                    $0.animation = animation
                }
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.value == rhs.value
        }
    }

    public func body(content: Content) -> SomeView {
        ContentWrapper(content: content, animation: animation, value: value)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
            && lhs.animation == rhs.animation
    }
}

public struct _AnimationView<Content>: View
    where Content: Equatable, Content: View {

    public let content: Content
    public let animation: Animation?

    @inlinable
    public init(content: Content, animation: Animation?) {
        self.content = content
        self.animation = animation
    }

    public var body: SomeView {
        content
            .modifier(_AnimationModifier(animation: animation, value: content))
    }
}

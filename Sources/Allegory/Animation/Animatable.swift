//
// Created by Mike on 8/14/21.
//

/// A type that describes how to animate a property of a view.
public protocol Animatable {

    /// The type defining the data to animate.
    associatedtype AnimatableData: VectorArithmetic

    /// The data to animate.
    var animatableData: Self.AnimatableData { get set }
}

extension Animatable where Self: VectorArithmetic {
    public var animatableData: Self {
        get { self }
        // swiftlint:disable:next unused_setter_value
        set {}
    }
}

extension Animatable where Self.AnimatableData == EmptyAnimatableData {
    public var animatableData: EmptyAnimatableData {
        @inlinable get { EmptyAnimatableData() }
        // swiftlint:disable:next unused_setter_value
        @inlinable set {}
    }
}

public struct EmptyAnimatableData: VectorArithmetic {
    @inlinable
    public init() {}

    @inlinable
    public static var zero: Self { .init() }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {}

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {}

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        .zero
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        .zero
    }

    @inlinable
    public mutating func scale(by rhs: Double) {}

    @inlinable
    public var magnitudeSquared: Double { .zero }

    public static func == (a: Self, b: Self) -> Bool { true }
}

/// A pair of animatable values, which is itself animatable.
public struct AnimatablePair<First, Second>: VectorArithmetic
    where First: VectorArithmetic, Second: VectorArithmetic {

    /// The first value.
    public var first: First

    /// The second value.
    public var second: Second

    /// Creates an animated pair with the provided values.
    @inlinable
    public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }

    @inlinable
    internal subscript() -> (First, Second) {
        get { (first, second) }
        set { (first, second) = newValue }
    }

    @_transparent public static var zero: Self {
        @_transparent get {
            .init(First.zero, Second.zero)
        }
    }

    @_transparent
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.first += rhs.first
        lhs.second += rhs.second
    }

    @_transparent
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.first -= rhs.first
        lhs.second -= rhs.second
    }

    @_transparent
    public static func + (lhs: Self, rhs: Self) -> Self {
        .init(lhs.first + rhs.first, lhs.second + rhs.second)
    }

    @_transparent
    public static func - (lhs: Self, rhs: Self) -> Self {
        .init(lhs.first - rhs.first, lhs.second - rhs.second)
    }

    /// Multiplies each component of this value by the given value.
    @_transparent
    public mutating func scale(by rhs: Double) {
        first.scale(by: rhs)
        second.scale(by: rhs)
    }

    /// The dot-product of this animated pair with itself.
    @_transparent public var magnitudeSquared: Double {
        @_transparent get {
            first.magnitudeSquared + second.magnitudeSquared
        }
    }

    public static func == (a: Self, b: Self) -> Bool {
        a.first == b.first
            && a.second == b.second
    }
}

extension CGPoint: Animatable {
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        @inlinable get { .init(x, y) }
        @inlinable set { (x, y) = newValue[] }
    }
}

extension CGSize: Animatable {
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        @inlinable get { .init(width, height) }
        @inlinable set { (width, height) = newValue[] }
    }
}

extension CGRect: Animatable {
    public var animatableData: AnimatablePair<CGPoint.AnimatableData, CGSize.AnimatableData> {
        @inlinable get {
            .init(origin.animatableData, size.animatableData)
        }
        @inlinable set {
            (origin.animatableData, size.animatableData) = newValue[]
        }
    }
}

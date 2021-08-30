//
// Created by Mike on 8/29/21.
//

public struct _Velocity<Value>: Equatable where Value: Equatable {
    public var valuePerSecond: Value

    @inlinable
    public init(valuePerSecond: Value) {
        self.valuePerSecond = valuePerSecond
    }

    public static func == (a: _Velocity<Value>, b: _Velocity<Value>) -> Bool {
        a.valuePerSecond == b.valuePerSecond
    }
}

extension _Velocity: Comparable where Value: Comparable {
    public static func < (lhs: _Velocity<Value>, rhs: _Velocity<Value>) -> Bool {
        lhs.valuePerSecond < rhs.valuePerSecond
    }
}

extension _Velocity: Animatable where Value: Animatable {
    public typealias AnimatableData = Value.AnimatableData

    public var animatableData: _Velocity<Value>.AnimatableData {
        @inlinable get { valuePerSecond.animatableData }
        @inlinable set { valuePerSecond.animatableData = newValue }
    }
}

extension _Velocity: AdditiveArithmetic where Value: AdditiveArithmetic {
    @inlinable
    public init() {
        self.init(valuePerSecond: .zero)
    }

    @inlinable
    public static var zero: _Velocity<Value> {
        get {
            .init(valuePerSecond: .zero)
        }
    }

    @inlinable
    public static func += (lhs: inout _Velocity<Value>, rhs: _Velocity<Value>) {
        lhs.valuePerSecond += rhs.valuePerSecond
    }

    @inlinable
    public static func -= (lhs: inout _Velocity<Value>, rhs: _Velocity<Value>) {
        lhs.valuePerSecond -= rhs.valuePerSecond
    }

    @inlinable
    public static func + (lhs: _Velocity<Value>, rhs: _Velocity<Value>) -> _Velocity<Value> {
        var r = lhs; r += rhs; return r
    }

    @inlinable
    public static func - (lhs: _Velocity<Value>, rhs: _Velocity<Value>) -> _Velocity<Value> {
        var r = lhs; r -= rhs; return r
    }
}

extension _Velocity: VectorArithmetic where Value: VectorArithmetic {
    @inlinable
    public mutating func scale(by rhs: Double) {
        valuePerSecond.scale(by: rhs)
    }

    @inlinable
    public var magnitudeSquared: Double {
        get {
            valuePerSecond.magnitudeSquared
        }
    }
}

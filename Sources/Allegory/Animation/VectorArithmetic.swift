//
// Created by Mike on 8/14/21.
//

public protocol VectorArithmetic: AdditiveArithmetic {
    mutating func scale(by rhs: Double)
    var magnitudeSquared: Double { get }
}

extension Float: VectorArithmetic {
    @_transparent
    public mutating func scale(by rhs: Double) { self *= Float(rhs) }
    @_transparent public var magnitudeSquared: Double {
        @_transparent get { Double(self * self) }
    }
}

extension Double: VectorArithmetic {
    @_transparent
    public mutating func scale(by rhs: Double) { self *= rhs }
    @_transparent public var magnitudeSquared: Double {
        @_transparent get { self * self }
    }
}

extension CGFloat: VectorArithmetic {
    @_transparent
    public mutating func scale(by rhs: Double) { self *= CGFloat(rhs) }
    @_transparent public var magnitudeSquared: Double {
        @_transparent get { Double(self * self) }
    }
}

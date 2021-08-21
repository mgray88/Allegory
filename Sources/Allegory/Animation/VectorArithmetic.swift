//
// Created by Mike on 8/14/21.
//

/// A type that can serve as the animatable data of an animatable type.
///
/// `VectorArithmetic` extends the `AdditiveArithmetic` protocol with scalar
/// multiplication and a way to query the vector magnitude of the value. Use
/// this type as the `animatableData` associated type of a type that conforms to
/// the ``Animatable`` protocol.
public protocol VectorArithmetic: AdditiveArithmetic {

    /// Multiplies each component of this value by the given value.
    mutating func scale(by rhs: Double)

    /// Returns the dot-product of this vector arithmetic instance with itself.
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

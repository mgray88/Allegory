//
// Created by Mike on 8/14/21.
//

/// An effect that changes the visual appearance of a view, largely without
/// changing its ancestors or descendants.
///
/// The only change the effect makes to the view's ancestors and descendants is
/// to change the coordinate transform to and from them.
// FIXME: Make `Animatable`
public protocol GeometryEffect: Animatable, ViewModifier {

    /// Returns the current value of the effect.
    func effectValue(size: CGSize) -> ProjectionTransform
}

public struct ProjectionTransform: Equatable {
    public var m11: CGFloat = 1, m12: CGFloat = 0, m13: CGFloat = 0
    public var m21: CGFloat = 0, m22: CGFloat = 1, m23: CGFloat = 0
    public var m31: CGFloat = 0, m32: CGFloat = 0, m33: CGFloat = 1
    public init() {}
    public init(_ m: CGAffineTransform) {
        m11 = m.a
        m12 = m.b
        m21 = m.c
        m22 = m.d
        m31 = m.tx
        m32 = m.ty
    }

    public var isIdentity: Bool {
        self == ProjectionTransform()
    }

    public var isAffine: Bool {
        m13 == 0 && m23 == 0 && m33 == 1
    }

    public mutating func invert() -> Bool {
        self = inverted()
        return true
    }

    public func inverted() -> ProjectionTransform {
        .init(CGAffineTransform(a: m11, b: m12, c: m21, d: m22, tx: m31, ty: m32).inverted())
    }
}
extension ProjectionTransform {
    @inline(__always)
    @inlinable
    internal func dot(
        _ a: (CGFloat, CGFloat, CGFloat),
        _ b: (CGFloat, CGFloat, CGFloat)
    ) -> CGFloat {
        a.0 * b.0 + a.1 * b.1 + a.2 * b.2
    }

    @inlinable
    public func concatenating(
        _ rhs: ProjectionTransform
    ) -> ProjectionTransform {
        var m = ProjectionTransform()
        m.m11 = dot((m11, m12, m13), (rhs.m11, rhs.m21, rhs.m31))
        m.m12 = dot((m11, m12, m13), (rhs.m12, rhs.m22, rhs.m32))
        m.m13 = dot((m11, m12, m13), (rhs.m13, rhs.m23, rhs.m33))
        m.m21 = dot((m21, m22, m23), (rhs.m11, rhs.m21, rhs.m31))
        m.m22 = dot((m21, m22, m23), (rhs.m12, rhs.m22, rhs.m32))
        m.m23 = dot((m21, m22, m23), (rhs.m13, rhs.m23, rhs.m33))
        m.m31 = dot((m31, m32, m33), (rhs.m11, rhs.m21, rhs.m31))
        m.m32 = dot((m31, m32, m33), (rhs.m12, rhs.m22, rhs.m32))
        m.m33 = dot((m31, m32, m33), (rhs.m13, rhs.m23, rhs.m33))
        return m
    }
}

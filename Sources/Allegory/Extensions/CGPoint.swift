//
// Created by Mike on 7/31/21.
//

#if canImport(CoreGraphics)

    import CoreGraphics

    public typealias CGPoint = CoreGraphics.CGPoint

#else

    public struct CGPoint: Equatable {

        public static let zero = CGPoint(x: 0, y: 0)

        public var x: CGFloat
        public var y: CGFloat

        @inlinable
        public init(x: CGFloat, y: CGFloat) {
            self.x = x
            self.y = y
        }
    }

#endif

extension CGPoint {
    @inlinable
    public func roundedToScale(scale: CGFloat) -> CGPoint {
        CGPoint(
            x: x.roundedToScale(scale: scale, rule: .toNearestOrAwayFromZero),
            y: y.roundedToScale(scale: scale, rule: .toNearestOrAwayFromZero)
        )
    }
}

extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }
}

extension CGPoint {
    public func rotate(_ angle: Angle, around origin: Self) -> Self {
        let cosAngle = CGFloat(cos(angle.radians))
        let sinAngle = CGFloat(sin(angle.radians))
        return .init(
            x: cosAngle * (x - origin.x) - sinAngle * (y - origin.y) + origin.x,
            y: sinAngle * (x - origin.x) + cosAngle * (y - origin.y) + origin.y
        )
    }

    public func offset(by offset: Self) -> Self {
        .init(
            x: x + offset.x,
            y: y + offset.y
        )
    }
}

extension CGPoint {
    public func applying(_ m: ProjectionTransform) -> CGPoint {
        CGPoint(
            x: (m.m11 * x + m.m12 * x + m.m13 * x),
            y: (m.m21 * y + m.m22 * y + m.m23 * y)
        )
    }
}

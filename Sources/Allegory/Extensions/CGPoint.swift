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

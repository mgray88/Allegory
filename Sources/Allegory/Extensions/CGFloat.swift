//
// Created by Mike on 7/31/21.
//

#if canImport(CoreGraphics)

    import CoreGraphics

    public typealias CGFloat = CoreGraphics.CGFloat

#else

    #if (arch(i386) || arch(arm))

        public typealias CGFloat = Float

    #else

        public typealias CGFloat = Double

    #endif

#endif

extension CGFloat {
    @inlinable
    public func roundedToScale(scale: CGFloat, rule: FloatingPointRoundingRule) -> CGFloat {
        let scale: CGFloat = 1.0 / scale
        return scale * (self / scale).rounded(rule)
    }
}

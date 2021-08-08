//
// Created by Mike on 7/31/21.
//

#if canImport(CoreGraphics)

    import CoreGraphics

    public typealias CGSize = CoreGraphics.CGSize

#else

    public struct CGSize: Equatable {

        public static let zero = CGSize(width: 0, height: 0)

        public var width: CGFloat
        public var height: CGFloat

        @inlinable
        public init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
        }
    }

#endif

extension CGSize: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

extension CGSize {

    var flipped: CGSize {
        CGSize(width: height, height: width)
    }

    func verticallyAdding(_ other: CGSize) -> CGSize {
        CGSize(
            width: max(width, other.width),
            height: height + other.height
        )
    }

    func horizontallyAdding(_ other: CGSize) -> CGSize {
        CGSize(width: width + other.width, height: max(height, other.height))
    }

    func intersection(_ other: CGSize) -> CGSize {
        CGSize(
            width: min(width, other.width),
            height: min(height, other.height)
        )
    }

    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}

extension CGSize {
    @inlinable
    public func roundedToScale(scale: CGFloat) -> CGSize {
        CGSize(
            width: width.roundedToScale(scale: scale, rule: .awayFromZero),
            height: height.roundedToScale(scale: scale, rule: .awayFromZero)
        )
    }
}

extension CGSize {
    func aligned(in bounds: Bounds, _ alignment: Alignment) -> Bounds {
        let parentPoint = alignment.point(for: bounds.size)
        let childPoint = alignment.point(for: self)
        let origin = parentPoint - childPoint
        return bounds.update(
            to: CGRect(
                origin: origin,
                size: self
            )
            .offsetBy(
                dx: bounds.rect.minX,
                dy: bounds.rect.minY
            )
        )
    }
}

func max(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    CGSize(width: max(lhs.width, rhs.width), height: max(lhs.height, rhs.height))
}

func min(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    CGSize(width: min(lhs.width, rhs.width), height: min(lhs.height, rhs.height))
}

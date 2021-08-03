//
// Created by Mike on 7/30/21.
//

#if canImport(CoreGraphics)

    import CoreGraphics

    public typealias CGRect = CoreGraphics.CGRect

#else

public struct CGRect: Equatable {

    public var origin: CGPoint

    public var size: CGSize

    public init() {
        self.init(origin: .zero, size: .zero)
    }

    public init(origin: CGPoint, size: CGSize) {
        self.origin = origin
        self.size = size
    }
}

extension CGRect {

    public static var zero: CGRect { .init() }

    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
}

#endif

extension CGRect {

    var flipped: CGRect {
        CGRect(x: origin.y, y: origin.x, width: height, height: width)
    }

    func inset(by insets: EdgeInsets) -> CGRect {
        CGRect(
            x: minX + CGFloat(insets.leading),
            y: minY + CGFloat(insets.top),
            width: width - CGFloat(insets.leading + insets.trailing),
            height: height - CGFloat(insets.top + insets.bottom)
        )
    }
}

extension CGRect {

    @inlinable
    public func roundedToScale(scale: CGFloat) -> CGRect {
        CGRect(
            origin: origin.roundedToScale(scale: scale),
            size: size.roundedToScale(scale: scale)
        )
    }
}

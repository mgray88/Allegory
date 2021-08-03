//
// Created by Mike on 7/30/21.
//

/// A capsule shape aligned inside the frame of the view containing it.
///
/// A capsule shape is equivalent to a rounded rectangle where the corner radius
/// is chosen as half the length of the rectangle’s smallest edge.
public struct Capsule: Shape {

    public typealias Body = _ShapeView<Self, ForegroundStyle>

    public var style: RoundedCornerStyle

    public init(style: RoundedCornerStyle = .circular) {
        self.style = style
    }

    @inlinable
    public func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        guard rect.width >= radius * 2 else { return Path(CGRect.zero) }
        guard rect.height >= radius * 2 else { return Path(CGRect.zero) }
        return Path(roundedRect: rect, cornerRadius: radius)
    }

    public var body: _ShapeView<Capsule, ForegroundStyle> {
        _ShapeView(shape: self, style: ForegroundStyle())
    }
}

extension Capsule: InsettableShape {
    public struct _Inset: Shape, InsettableShape {
        internal let inset: CGFloat

        public func path(in rect: CGRect) -> Path {
            Path(rect.insetBy(dx: inset, dy: inset))
        }

        public func inset(by amount: CGFloat) -> Self {
            _Inset(inset: inset + amount)
        }
    }

    public func inset(by amount: CGFloat) -> _Inset {
        _Inset(inset: amount)
    }
}

extension Capsule: ShapeRenderable {}
extension Capsule._Inset: ShapeRenderable {}

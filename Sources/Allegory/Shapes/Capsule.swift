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
        .init(storage: .roundedRect(.init(capsule: rect, style: style)))
    }

    public var body: _ShapeView<Capsule, ForegroundStyle> {
        _ShapeView(shape: self, style: ForegroundStyle())
    }
}

extension Capsule: InsettableShape {
    public struct _Inset: Shape, InsettableShape {
        @usableFromInline
        internal var inset: CGFloat

        @usableFromInline
        internal init(inset: CGFloat) {
            self.inset = inset
        }

        @inlinable
        public func path(in rect: CGRect) -> Path {
            Path(rect.insetBy(dx: inset, dy: inset))
        }

        @inlinable
        public func inset(by amount: CGFloat) -> Self {
            _Inset(inset: inset + amount)
        }
    }

    @inlinable
    public func inset(by amount: CGFloat) -> _Inset {
        _Inset(inset: amount)
    }
}

extension Capsule: ShapeRenderable {}
extension Capsule._Inset: ShapeRenderable {}

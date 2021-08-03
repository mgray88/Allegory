//
// Created by Mike on 8/1/21.
//

/// An ellipse aligned inside the frame of the view containing it.
public struct Ellipse: Shape, View {

    public init() {}

    public var body: _ShapeView<Self, ForegroundStyle> {
        _ShapeView(shape: self, style: ForegroundStyle())
    }

    public func path(in rect: CGRect) -> Path {
        Path(ellipseIn: rect)
    }
}

extension Ellipse: InsettableShape {
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

extension Ellipse: ShapeRenderable {}
extension Ellipse._Inset: ShapeRenderable {}

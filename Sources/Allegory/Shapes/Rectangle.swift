//
// Created by Mike on 7/29/21.
//

public struct Rectangle: Shape, View {

    public init() {}

    public var body: _ShapeView<Self, ForegroundStyle> {
        _ShapeView(shape: self, style: ForegroundStyle())
    }

    public func path(in rect: CGRect) -> Path {
        Path(rect)
    }
}

extension Rectangle: InsettableShape {
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

extension Rectangle: ShapeRenderable {}
extension Rectangle._Inset: ShapeRenderable {}

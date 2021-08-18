//
// Created by Mike on 8/1/21.
//

/// A circle centered on the frame of the view containing it.
///
/// The circle’s radius equals half the length of the frame rectangle’s smallest
/// edge.
public struct Circle: Shape, Equatable {

    @inlinable
    public init() {}

    @inlinable
    public func path(in rect: CGRect) -> Path {
        .init(storage: .ellipse(rect))
    }

    public typealias AnimatableData = EmptyAnimatableData
    public typealias Body = _ShapeView<Circle, ForegroundStyle>
}

extension Circle: InsettableShape {
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

extension Circle: ShapeRenderable {}
extension Circle._Inset: ShapeRenderable {}

//
// Created by Mike on 8/1/21.
//

/// A circle centered on the frame of the view containing it.
///
/// The circle’s radius equals half the length of the frame rectangle’s smallest
/// edge.
public struct Circle: Shape, Equatable {

    public init() {}

    @inlinable
    public func path(in rect: CGRect) -> Path {
        guard !rect.isEmpty else { return Path(CGRect.zero) }
        var rect = rect
        if rect.width < rect.height {
            rect.origin.y = (rect.height - rect.width) / 2
            rect.size.height = rect.width
        } else if rect.width > rect.height {
            rect.origin.x = (rect.width - rect.height) / 2
            rect.size.width = rect.height
        }
        return Path(ellipseIn: rect)
    }
}

extension Circle: InsettableShape {
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

extension Circle: ShapeRenderable {}
extension Circle._Inset: ShapeRenderable {}

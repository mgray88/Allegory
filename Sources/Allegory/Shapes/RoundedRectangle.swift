//
// Created by Mike on 8/1/21.
//

/// A rectangular shape with rounded corners, aligned inside the frame of the
/// view containing it.
public struct RoundedRectangle: Shape, Hashable {
    public var cornerSize: CGSize
    public var style: RoundedCornerStyle

    @inlinable
    public init(cornerSize: CGSize, style: RoundedCornerStyle = .circular) {
        self.cornerSize = cornerSize
        self.style = style
    }

    @inlinable
    public init(cornerRadius: CGFloat, style: RoundedCornerStyle = .circular) {
        self.cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        self.style = style
    }

    @inlinable
    public func path(in rect: CGRect) -> Path {
        guard rect.width >= cornerSize.width * 2 else { return Path(CGRect.zero) }
        guard rect.height >= cornerSize.height * 2 else { return Path(CGRect.zero) }
        return Path(roundedRect: rect, cornerSize: cornerSize)
    }
}

extension RoundedRectangle: InsettableShape {
    public struct _Inset: Shape, InsettableShape {
        internal var inset: CGFloat

        public func path(in rect: CGRect) -> Path {
            Path(rect.insetBy(dx: inset, dy: inset))
        }

        public func inset(by amount: CGFloat) -> Self {
            var copy = self
            copy.inset += amount
            return copy
        }
    }

    public func inset(by amount: CGFloat) -> _Inset {
        _Inset(inset: amount)
    }
}

extension RoundedRectangle: ShapeRenderable {}
extension RoundedRectangle._Inset: ShapeRenderable {}

//
// Created by Mike on 8/1/21.
//

/// A view’s size and its alignment guides in its own coordinate space.
public struct ViewDimensions: Equatable {
    /// The view’s height.
    @usableFromInline let height: CGFloat

    /// The view’s width.
    @usableFromInline let width: CGFloat

    @inlinable
    internal init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
    }

    /// Gets the value of the given horizontal guide.
    @inlinable
    public subscript(guide: HorizontalAlignment) -> CGFloat {
        guide.alignmentID.defaultValue(in: self)
    }

    /// Gets the value of the given vertical guide.
    @inlinable
    public subscript(guide: VerticalAlignment) -> CGFloat {
        guide.alignmentID.defaultValue(in: self)
    }

    /// Gets the explicit value of the given alignment guide in this view, or
    /// `nil` if no such value exists.
    @inlinable
    public subscript(explicit guide: HorizontalAlignment) -> CGFloat? {
        TODO()
    }

    /// Gets the explicit value of the given alignment guide in this view, or
    /// `nil` if no such value exists.
    @inlinable
    public subscript(explicit guide: VerticalAlignment) -> CGFloat? {
        TODO()
    }
}

extension ViewDimensions {
    @inlinable
    internal init(_ height: CGFloat, _ width: CGFloat) {
        self.init(height: height, width: width)
    }

    @inlinable
    internal init(_ size: CGSize) {
        self.init(height: size.height, width: size.width)
    }
}

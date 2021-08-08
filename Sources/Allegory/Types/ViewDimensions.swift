//
// Created by Mike on 8/1/21.
//

/// A view’s size and its alignment guides in its own coordinate space.
public struct ViewDimensions: Equatable {
    /// The view’s height.
    let height: CGFloat

    /// The view’s width.
    let width: CGFloat

    /// Gets the value of the given horizontal guide.
    public subscript(guide: HorizontalAlignment) -> CGFloat {
        TODO()
    }

    /// Gets the value of the given vertical guide.
    public subscript(guide: VerticalAlignment) -> CGFloat {
        TODO()
    }

    /// Gets the explicit value of the given alignment guide in this view, or
    /// `nil` if no such value exists.
    public subscript(explicit guide: HorizontalAlignment) -> CGFloat? {
        TODO()
    }

    /// Gets the explicit value of the given alignment guide in this view, or
    /// `nil` if no such value exists.
    public subscript(explicit guide: VerticalAlignment) -> CGFloat? {
        TODO()
    }
}

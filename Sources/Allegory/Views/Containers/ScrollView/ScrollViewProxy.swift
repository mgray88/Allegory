//
// Created by Mike on 8/11/21.
//

/// A proxy value that supports programmatic scrolling of the scrollable
/// views within a view hierarchy.
///
/// You don't create instances of `ScrollViewProxy` directly. Instead, your
/// ``ScrollViewReader`` receives an instance of `ScrollViewProxy` in its
/// `content` view builder. You use actions within this view builder, such
/// as button and gesture handlers or the ``View/onChange(of:perform:)``
/// method, to call the proxy's ``ScrollViewProxy/scrollTo(_:anchor:)`` method.
public struct ScrollViewProxy {

    /// Scans all scroll views contained by the proxy for the first
    /// with a child view with identifier `id`, and then scrolls to
    /// that view.
    ///
    /// If `anchor` is `nil`, this method finds the container of the identified
    /// view, and scrolls the minimum amount to make the identified view
    /// wholly visible.
    ///
    /// If `anchor` is non-`nil`, it defines the points in the identified
    /// view and the scroll view to align. For example, setting `anchor` to
    /// ``UnitPoint/top`` aligns the top of the identified view to the top of
    /// the scroll view. Similarly, setting `anchor` to ``UnitPoint/bottom``
    /// aligns the bottom of the identified view to the bottom of the scroll
    /// view, and so on.
    ///
    /// - Parameters:
    ///   - id: The identifier of a child view to scroll to.
    ///   - anchor: The alignment behavior of the scroll action.
    public func scrollTo<ID>(
        _ id: ID,
        anchor: UnitPoint? = nil
    ) where ID: Hashable {
    }
}

//
// Created by Mike on 7/29/21.
//

/// An interface for a stored variable that updates an external property of a
/// view.
///
/// The view gives values to these properties prior to recomputing the view's
/// ``View/body``.
public protocol DynamicProperty {
    /// Updates the underlying value of the stored value.
    ///
    /// Allegory calls this function before rendering a view's ``View/body`` to
    /// ensure the view has the most recent value.
    mutating func update()
}

extension DynamicProperty {
    public func update() {}
}

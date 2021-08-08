//
// Created by Mike on 7/29/21.
//

/// A type-erased view.
///
/// An `AnyView` allows changing the type of view used in a given view
/// hierarchy. Whenever the type of view used with an `AnyView` changes, the old
/// hierarchy is destroyed and a new hierarchy is created for the new type.
public struct AnyView: View {
    public typealias Body = Swift.Never

    internal let view: SomeView

    /// Create an instance that type-erases `view`.
    public init<V>(_ view: V) where V: View {
        self.view = view
    }
}

extension AnyView: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        view.resolve(context: context, cachedNode: cachedNode)
    }
}

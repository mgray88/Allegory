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

    internal let storage: AnyViewStorageBase

    /// Create an instance that type-erases `view`.
    public init<V>(_ view: V) where V: View {
        if let anyView = view as? AnyView {
            self = anyView
        } else {
            storage = AnyViewStorage(view: view)
        }
    }

    public init(some view: SomeView) {
        if let anyView = view as? AnyView {
            self = anyView
        } else {
            storage = SomeViewStorage(view: view)
        }
    }

    public init<V>(erasing view: V) where V: View {
        self.init(view)
    }
}

extension AnyView: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        storage.resolve(context: context, cachedNode: cachedNode)
    }
}

internal class AnyViewStorageBase {
    fileprivate func size() -> CGSize {
        abstractMethod()
    }
    fileprivate func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        abstractMethod()
    }
}

fileprivate class AnyViewStorage<V: View>: AnyViewStorageBase {
    let view: V

    init(view: V) {
        self.view = view
        super.init()
    }

    override func size() -> CGSize {
        TODO()
    }

    override func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        view.resolve(context: context, cachedNode: cachedNode)
    }
}

fileprivate class SomeViewStorage: AnyViewStorageBase {
    let view: SomeView

    init(view: SomeView) {
        self.view = view
        super.init()
    }

    override func size() -> CGSize {
        TODO()
    }

    override func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        view.resolve(context: context, cachedNode: cachedNode)
    }
}

//
// Created by Mike on 7/31/21.
//

extension ViewModifiers {
    public struct _EnvironmentObject: ViewModifier {
        public let object: Any
        public let objectTypeIdentifier: String

        @inlinable
        public init<Object: ObservableObject>(
            _ object: Object,
            objectTypeIdentifier: String
        ) {
            self.object = object
            self.objectTypeIdentifier = objectTypeIdentifier
        }
    }
}

extension View {
    /// Supplies an ``ObservableObject`` to a view subhierarchy.
    ///
    /// - Parameter object: The object to store and make available to the view's
    ///   subhierarchy.
    /// - Returns: The object can be read by any child by using
    ///   ``EnvironmentObject``.
    @inlinable
    public func environmentObject<T>(
        _ object: T
    ) -> ModifiedContent<Self, ViewModifiers._EnvironmentObject>
        where T: ObservableObject {
        modifier(
            ViewModifiers._EnvironmentObject(
                object,
                objectTypeIdentifier: String(reflecting: T.self)
            )
        )
    }
}

extension ViewModifiers._EnvironmentObject: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "EnvironmentObject"
        }

        func update(
            viewModifier: ViewModifiers._EnvironmentObject,
            context: inout Context
        ) {
            context.environmentObjects[viewModifier.objectTypeIdentifier] =
                viewModifier.object
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

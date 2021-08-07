//
// Created by Mike on 7/29/21.
//

import Foundation

internal protocol EnvironmentObjectStorage {
    var get: () -> Any { get set }
    var set: (Any) -> Void { get set }
    var objectTypeIdentifier: String { get }
}

internal protocol EnvironmentObjectProperty: DynamicProperty {
    var storage: EnvironmentObjectStorage { get set }
}

/// A property wrapper type for an observable object supplied by a parent or
/// ancestor view.
///
/// An environment object invalidates the current view whenever the observable
/// object changes. If you declare a property as an environment object, be sure
/// to set a corresponding model object on an ancestor view by calling its
/// ``View/environmentObject(_:)`` modifier.
@propertyWrapper
public struct EnvironmentObject<ObjectType>: EnvironmentObjectProperty
    where ObjectType: ObservableObject {

    /// A wrapper of the underlying environment object that can create bindings
    /// to its properties using dynamic member lookup.
    @dynamicMemberLookup
    public struct Wrapper: EnvironmentObjectStorage {
        internal var get: () -> Any
        internal var set: (Any) -> Void
        internal let objectTypeIdentifier: String

        internal init(
            objectTypeIdentifier: String,
            get: @escaping () -> Any,
            set: @escaping (Any) -> Void
        ) {
            self.get = get
            self.set = set
            self.objectTypeIdentifier = objectTypeIdentifier
        }

        private func _get() -> ObjectType {
            get() as! ObjectType
        }

        /// Returns a binding to the resulting value of a given key path.
        ///
        /// - Parameter keyPath: A key path to a specific resulting value.
        /// - Returns: A new binding.
        public subscript<Subject>(
            dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
        ) -> Binding<Subject> {
            Binding(
                get: { _get()[keyPath: keyPath] },
                set: { _get()[keyPath: keyPath] = $0 }
            )
        }
    }

    internal var storage: EnvironmentObjectStorage = Wrapper(
        objectTypeIdentifier: String(reflecting: ObjectType.self),
        get: { fatalError() },
        set: { _ in }
    )

    public var wrappedValue: ObjectType {
        get {
            storage.get() as! ObjectType
        }
        set {
            storage.set(newValue)
        }
    }

    /// A projection of the environment object that creates bindings to its
    /// properties using dynamic member lookup.
    ///
    /// Use the projected value to pass an environment object down a view
    /// hierarchy.
    public var projectedValue: EnvironmentObject<ObjectType>.Wrapper {
        storage as! Wrapper
    }

    /// Creates an environment object.
    public init() {}
}

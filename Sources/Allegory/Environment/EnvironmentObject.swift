//
// Created by Mike on 7/29/21.
//

import Foundation
import RxSwift

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
public struct EnvironmentObject<ObjectType>: DynamicProperty
    where ObjectType: RxObservableObject {

    /// A wrapper of the underlying environment object that can create bindings
    /// to its properties using dynamic member lookup.
    @dynamicMemberLookup public struct Wrapper {
        internal let root: ObjectType
        public subscript<Subject>(
            dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
        ) -> Binding<Subject> {
            .init(
                get: {
                    self.root[keyPath: keyPath]
                }, set: {
                    self.root[keyPath: keyPath] = $0
                }
            )
        }
    }

    @usableFromInline
    var _store: ObjectType?

    @usableFromInline
    var _seed: Int = 0

    mutating func setContent(from values: EnvironmentValues) {
        _store = values[ObjectIdentifier(ObjectType.self)]
    }

    @inlinable
    public var wrappedValue: ObjectType {
        guard let store = _store else { error() }
        return store
    }

    /// A projection of the environment object that creates bindings to its
    /// properties using dynamic member lookup.
    ///
    /// Use the projected value to pass an environment object down a view
    /// hierarchy.
    public var projectedValue: Wrapper {
        guard let store = _store else { error() }
        return Wrapper(root: store)
    }

    var objectWillChange: Infallible<Void> {
        wrappedValue.objectWillChange.asInfallible(onErrorJustReturn: ())
    }

    @inlinable
    func error() -> Never {
        fatalError("No ObservableObject found for type \(ObjectType.self)")
    }

    /// Creates an environment object.
    public init() {}
}

extension EnvironmentObject: ObservedProperty, EnvironmentReader {}

extension RxObservableObject {
    static var environmentStore: WritableKeyPath<EnvironmentValues, Self?> {
        \EnvironmentValues[ObjectIdentifier(self)]
    }
}

extension View {

    /// Supplies an `ObservableObject` to a view subhierarchy.
    ///
    /// The object can be read by any child by using `EnvironmentObject`.
    ///
    /// - Parameter object: the object to store and make available to
    ///     the view's subhierarchy.
    public func environmentObject<B>(
        _ bindable: B
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<B?>> where B: RxObservableObject {
        environment(B.environmentStore, bindable)
    }
}

//
// Created by Mike on 7/29/21.
//

import RxSwift

protocol ObservedProperty: DynamicProperty {
    var objectWillChange: Infallible<Void> { get }
}

/// A property wrapper type that subscribes to an observable object and
/// invalidates a view whenever the observable object changes.
@propertyWrapper
public struct RxObservedObject<ObjectType>: ObservedProperty
    where ObjectType: RxObservableObject {

    /// A wrapper of the underlying observable object that can create bindings
    /// to its properties using dynamic member lookup.
    @dynamicMemberLookup
    public struct Wrapper {
        internal var value: ObjectType

        /// Returns a binding to the resulting value of a given key path.
        ///
        /// - Parameter keyPath: A key path to a specific resulting value.
        /// - Returns: A new binding.
        public subscript<Subject>(
            dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
        ) -> Binding<Subject> {
            get {
                Binding(
                    get: { value[keyPath: keyPath] },
                    set: { value[keyPath: keyPath] = $0 }
                )
            }
        }
    }

    /// Creates an observed object with an initial value.
    ///
    /// - Parameter initialValue: An initial value.
    public init(initialValue: ObjectType) {
        projectedValue = Wrapper(value: initialValue)
    }

    /// Creates an observed object with an initial wrapped value.
    ///
    /// You don't call this initializer directly. Instead, declare a property
    /// with the `@ObservedObject` attribute, and provide an initial value.
    ///
    /// - Parameter wrappedValue: An initial value.
    public init(wrappedValue: ObjectType) {
        projectedValue = Wrapper(value: wrappedValue)
    }

    /// The underlying value referenced by the observed object.
    ///
    /// This property provides primary access to the value's data. However, you
    /// don't access `wrappedValue` directly. Instead, you use the property
    /// variable created with the `@ObservedObject` attribute.
    ///
    /// When a mutable value changes, the new value is immediately available.
    /// However, a view displaying the value is updated asynchronously and may
    /// not show the new value immediately.
    public var wrappedValue: ObjectType {
        get {
            projectedValue.value
        }
        set {
            projectedValue.value = newValue
        }
    }

    /// A projection of the observed object that creates bindings to its
    /// properties using dynamic member lookup.
    ///
    /// Use the projected value to pass a binding value down a view hierarchy.
    /// To get the `projectedValue`, prefix the property variable with $.
    public var projectedValue: RxObservedObject<ObjectType>.Wrapper

    internal var objectWillChange: Infallible<Void> {
        wrappedValue.objectWillChange.asInfallible(onErrorJustReturn: ())
    }
}

extension RxObservedObject: Equatable {
    public static func == (lhs: RxObservedObject, rhs: RxObservedObject) -> Bool {
        lhs.wrappedValue === rhs.wrappedValue
    }
}

//extension Property {
//
//    public var binding: Binding<Value> {
//        return Binding(get: { self.value }, set: { self.value = $0 })
//    }
//}

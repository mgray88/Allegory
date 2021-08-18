//
// Created by Mike on 8/11/21.
//

/// A property wrapper type that instantiates an observable object.
///
/// Create a state object in a ``Allegory/View``, ``Allegory/App``, or
/// ``Allegory/Scene`` by applying the `@StateObject` attribute to a property
/// declaration and providing an initial value that conforms to the
/// ``RxObservableObject`` protocol:
///
///     @StateObject var model = DataModel()
///
/// Allegory creates a new instance of the object only once for each instance of
/// the structure that declares the object. When published properties of the
/// observable object change, Allegory updates the parts of any view that depend
/// on those properties:
///
///     Text(model.title) // Updates the view any time `title` changes.
///
/// You can pass the state object into a property that has the
/// ``Allegory/RxObservedObject`` attribute. You can alternatively add the object
/// to the environment of a view hierarchy by applying the
/// ``Allegory/View/environmentObject(_:)`` modifier:
///
///     ContentView()
///         .environmentObject(model)
///
/// If you create an environment object as shown in the code above, you can
/// read the object inside `ContentView` or any of its descendants
/// using the ``Allegory/EnvironmentObject`` attribute:
///
///     @EnvironmentObject var model: DataModel
///
/// Get a ``Allegory/Binding`` to one of the state object's properties using the
/// `$` operator. Use a binding when you want to create a two-way connection to
/// one of the object's properties. For example, you can let a
/// ``Allegory/Toggle`` control a Boolean value called `isEnabled` stored in the
/// model:
///
///     Toggle("Enabled", isOn: $model.isEnabled)
@propertyWrapper
public struct StateObject<ObjectType>: DynamicProperty
    where ObjectType: RxObservableObject {

    @usableFromInline
    internal enum Storage {
        case initially(() -> ObjectType)
        case object(RxObservedObject<ObjectType>)
    }

    @usableFromInline
    internal var storage: StateObject<ObjectType>.Storage

    /// Creates a new state object with an initial wrapped value.
    ///
    /// You don’t call this initializer directly. Instead, declare a property
    /// with the `@StateObject` attribute in a ``Allegory/View``,
    /// ``Allegory/App``, or ``Allegory/Scene``, and provide an initial value:
    ///
    ///     struct MyView: View {
    ///         @StateObject var model = DataModel()
    ///
    ///         // ...
    ///     }
    ///
    /// Allegory creates only one instance of the state object for each
    /// container instance that you declare. In the code above, Allegory
    /// creates `model` only the first time it initializes a particular instance
    /// of `MyView`. On the other hand, each different instance of `MyView`
    /// receives a distinct copy of the data model.
    ///
    /// - Parameter thunk: An initial value for the state object.
    @inlinable
    public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType) {
        storage = .initially(thunk)
    }

    // TODO: This does not store the value
    public var wrappedValue: ObjectType {
        get {
            switch storage {
            case let .initially(thunk):
                return thunk()

            case let .object(value):
                return value.wrappedValue
            }
        }
    }

    // TODO: This does not store the value
    public var projectedValue: RxObservedObject<ObjectType>.Wrapper {
        switch storage {
        case let .initially(thunk):
            return RxObservedObject(wrappedValue: thunk()).projectedValue

        case let .object(value):
            return value.projectedValue
        }
    }
}

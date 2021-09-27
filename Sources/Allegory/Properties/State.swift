//
// Created by Mike on 7/29/21.
//

protocol StateProperty: DynamicProperty {
    var storage: StateStorage { get }
    var value: Any { get nonmutating set }
}

/// A property wrapper type that can read and write a value managed by Allegory.
///
/// Allegory manages the storage of any property you declare as a state. When
/// the state value changes, the view invalidates its appearance and recomputes
/// the body. Use the state as the single source of truth for a given view.
///
/// A ``State`` instance isn't the value itself; it's a means of reading and
/// writing the value. To access a state's underlying value, use its variable
/// name, which returns the ``State/wrappedValue`` property value.
///
/// You should only access a state property from inside the view's body, or from
/// methods called by it. For this reason, declare your state properties as
/// private, to prevent clients of your view from accessing them. It is safe to
/// mutate state properties from any thread.
///
/// To pass a state property to another view in the view hierarchy, use the
/// variable name with the `$` prefix operator. This retrieves a binding of the
/// state property from its ``State/projectedValue`` property. For example, in
/// the following code example `PlayerView` passes its state property
/// `isPlaying` to `PlayButton` using `$isPlaying`:
///
///     struct PlayerView: View {
///         var episode: Episode
///         @State private var isPlaying: Bool = false
///
///         var body: some View {
///             VStack {
///                 Text(episode.title)
///                 Text(episode.showTitle)
///                 PlayButton(isPlaying: $isPlaying)
///             }
///         }
///     }
@propertyWrapper
public struct State<Value>: StateProperty {
    @usableFromInline
    internal var _value: Value

    @usableFromInline
    internal var _location: AnyLocation<Value>?

//    private var box: Box<StateBox<Value>>
//
    public let storage: StateStorage

    public init(wrappedValue value: Value) {
        _value = value
        self.storage = StateStorage(initialValue: value, get: { value }, set: { _ in })
//        self.box = Box(StateBox(value))
    }

    public init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }

    public var wrappedValue: Value {
        get {
            _location?.value ?? _value
        }
        nonmutating set {
            _location!.value = newValue
        }
    }

    public var projectedValue: Binding<Value> {
        _location!.binding
    }

    var value: Any {
        get { wrappedValue }
        nonmutating set { wrappedValue = newValue as! Value }
    }
}

extension State where Value: ExpressibleByNilLiteral {

    @inlinable
    public init() {
        self.init(wrappedValue: nil)
    }
}

public class StateStorage {

    public var initialValue: Any
    public var get: () -> Any
    public var set: (Any) -> Void

    @inlinable
    public init(initialValue: Any, get: @escaping () -> Any, set: @escaping (Any) -> Void) {
        self.initialValue = initialValue
        self.get = get
        self.set = set
    }
}

final class Box<Value> {
    var value: Value
    init(_ value: Value) {
        self.value = value
    }
}

final class Weak<A: AnyObject> {
    weak var value: A?

    init(_ value: A) {
        self.value = value
    }
}

var currentBodies: [Node] = []
var currentGlobalBodyNode: Node? { currentBodies.last }

final class StateBox<Value> {
    private var _value: Value
    private var dependencies: [Weak<Node>] = []
    var binding: Binding<Value> = Binding(get: { fatalError() }, set: { _ in fatalError() })

    init(_ value: Value) {
        self._value = value
        self.binding = Binding(get: { [unowned self] in
            self.value
        }, set: { [unowned self] in
            self.value = $0
        })
    }

    var value: Value {
        get {
            if let node = currentGlobalBodyNode {
                dependencies.append(Weak(node))
            }
            // skip duplicates and remove nil entries?
            return _value
        }
        set {
            _value = newValue
            for d in dependencies {
                d.value?.needsRebuild = true
            }
        }
    }
}

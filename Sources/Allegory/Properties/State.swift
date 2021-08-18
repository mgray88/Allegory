//
// Created by Mike on 7/29/21.
//

protocol StateProperty: DynamicProperty {
    var storage: StateStorage { get }
}

@propertyWrapper
public struct State<Value>: StateProperty {

    public let storage: StateStorage

    @inlinable
    public init(wrappedValue value: Value) {
        self.storage = StateStorage(initialValue: value, get: { value }, set: { _ in })
    }

    @inlinable
    public var wrappedValue: Value {
        get {
            storage.get() as! Value
        }
        nonmutating set {
            storage.set(newValue)
        }
    }

    @inlinable
    public var projectedValue: Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { value, _ in self.wrappedValue = value }
        )
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

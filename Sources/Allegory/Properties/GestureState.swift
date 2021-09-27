//
//  Created by Mike on 9/18/21.
//

/// TODO
@propertyWrapper
public struct GestureState<Value>: DynamicProperty {
    fileprivate var state: State<Value>
    fileprivate let reset: (Binding<Value>) -> Void

    public init(wrappedValue: Value) {
        self.init(initialValue: wrappedValue)
    }

    public init(initialValue: Value) {
        self.init(wrappedValue: initialValue, resetTransaction: Transaction())
    }

    public init(wrappedValue: Value, resetTransaction: Transaction) {
        TODO()
    }

    public init(initialValue: Value, resetTransaction: Transaction) {
      self.init(wrappedValue: initialValue, resetTransaction: resetTransaction)
    }

    public init(wrappedValue: Value, reset: @escaping (Value, inout Transaction) -> Void) {
        TODO()
    }

    public init(initialValue: Value, reset: @escaping (Value, inout Transaction) -> Void) {
      self.init(wrappedValue: initialValue, reset: reset)
    }

    public var wrappedValue: Value {
        state.wrappedValue
    }

    public var projectedValue: GestureState<Value> {
        self
    }
}

extension GestureState where Value: ExpressibleByNilLiteral {
    public init(resetTransaction: Transaction = Transaction()) {
        self.init(wrappedValue: nil, resetTransaction: resetTransaction)
    }

    public init(reset: @escaping (Value, inout Transaction) -> Void) {
        self.init(wrappedValue: nil, reset: reset)
    }
}

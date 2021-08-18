//
// Created by Mike on 8/14/21.
//

public struct _ViewTraitStore {
    public var values = [String: Any]()

    public init(values: [String: Any] = [:]) {
        self.values = values
    }

    public func value<Key>(
        forKey key: Key.Type = Key.self
    ) -> Key.Value where Key: _ViewTraitKey {
        values[String(reflecting: key)] as? Key.Value ?? Key.defaultValue
    }

    public mutating func insert<Key>(
        _ value: Key.Value,
        forKey key: Key.Type = Key.self
    ) where Key: _ViewTraitKey {
        values[String(reflecting: key)] = value
    }
}

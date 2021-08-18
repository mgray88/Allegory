////
//// Created by Mike on 8/14/21.
////
//
//public struct _PreferenceActionModifier<Key>: _PreferenceWritingModifierProtocol
//    where Key: PreferenceKey, Key.Value: Equatable {
//
//    public let action: (Key.Value) -> Void
//
//    @inlinable
//    public init(action: @escaping (Key.Value) -> Void) {
//        self.action = action
//    }
//
//    public func body(
//        _ content: Content,
//        with preferenceStore: inout _PreferenceStore
//    ) -> SomeView {
//        let value = preferenceStore.value(forKey: Key.self)
//        let previousValue = value.reduce(value.valueList.dropLast())
//        if previousValue != value.value {
//            action(value.value)
//        }
//        return content.view
//    }
//}
//
//extension View {
//
//    /// Adds an action to perform when the specified preference key's value
//    /// changes.
//    ///
//    /// - Parameters:
//    ///   - key: The key to monitor for value changes.
//    ///   - action: The action to perform when the value for `key` changes. The
//    ///     `action` closure passes the new value as its parameter.
//    ///
//    /// - Returns: A view that triggers `action` when the value for `key`
//    ///   changes.
//    @inlinable
//    public func onPreferenceChange<K>(
//        _ key: K.Type = K.self,
//        perform action: @escaping (K.Value) -> Void
//    ) -> ModifiedContent<Self, _PreferenceActionModifier<K>>
//        where K: PreferenceKey, K.Value: Equatable {
//
//        modifier(_PreferenceActionModifier<K>(action: action))
//    }
//}

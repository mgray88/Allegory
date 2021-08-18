////
//// Created by Mike on 8/14/21.
////
//
//public struct _PreferenceWritingModifier<Key>: _PreferenceWritingModifierProtocol
//    where Key: PreferenceKey {
//
//    public let value: Key.Value
//
//    @inlinable
//    public init(key: Key.Type = Key.self, value: Key.Value) {
//        self.value = value
//    }
//
//    public func body(
//        _ content: Content,
//        with preferenceStore: inout _PreferenceStore
//    ) -> SomeView {
//        preferenceStore.insert(value, forKey: Key.self)
//        return content.view
//    }
//}
//
//extension _PreferenceWritingModifier: Equatable where Key.Value: Equatable {
//    public static func == (a: Self, b: Self) -> Bool {
//        a.value == b.value
//    }
//}
//
//extension View {
//
//    /// Sets a value for the given preference.
//    @inlinable
//    public func preference<K>(
//        key: K.Type = K.self,
//        value: K.Value
//    ) -> ModifiedContent<Self, _PreferenceWritingModifier<K>>
//        where K: PreferenceKey {
//
//        modifier(_PreferenceWritingModifier<K>(value: value))
//    }
//}

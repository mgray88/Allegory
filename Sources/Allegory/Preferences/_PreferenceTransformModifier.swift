////
//// Created by Mike on 8/14/21.
////

/// Transforms a `PreferenceKey.Value`.
public struct _PreferenceTransformModifier<Key>: _PreferenceWritingModifierProtocol
    where Key: PreferenceKey {

    public let transform: (inout Key.Value) -> ()

    public init(
        key _: Key.Type = Key.self,
        transform: @escaping (inout Key.Value) -> ()
    ) {
        self.transform = transform
    }

    public func body(
        _ content: Content,
        with preferenceStore: inout _PreferenceStore
    ) -> SomeView {
        var newValue = preferenceStore.value(forKey: Key.self).value
        transform(&newValue)
        preferenceStore.insert(newValue, forKey: Key.self)
        return content.view
    }
}

public extension View {

    /// Applies a transformation to a preference value.
    func transformPreference<K>(
        _ key: K.Type = K.self,
        _ callback: @escaping (inout K.Value) -> ()
    ) -> ModifiedContent<Self, _PreferenceTransformModifier<K>>
        where K: PreferenceKey {
        modifier(_PreferenceTransformModifier<K>(transform: callback))
    }
}

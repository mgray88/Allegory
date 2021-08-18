////
//// Created by Mike on 8/14/21.
////
//
///// Delays the retrieval of a `PreferenceKey.Value` by passing the
///// `_PreferenceValue` to a build function.
//public struct _DelayedPreferenceView<Key, Content>: View, _PreferenceReadingViewProtocol
//    where Key: PreferenceKey, Content: View {
//
//    @State private var resolvedValue: _PreferenceValue<Key> = _PreferenceValue(
//        valueList: [Key.defaultValue]
//    )
//    public let transform: (_PreferenceValue<Key>) -> Content
//
//    @inlinable
//    public init(transform: @escaping (_PreferenceValue<Key>) -> Content) {
//        self.transform = transform
//    }
//
//    public func preferenceStore(_ preferenceStore: _PreferenceStore) {
//        resolvedValue = preferenceStore.value(forKey: Key.self)
//    }
//
//    public var body: SomeView {
//        transform(resolvedValue)
//    }
//}
//
//public struct _PreferenceReadingView<Key, Content>: View
//    where Key: PreferenceKey, Content: View {
//
//    public let value: _PreferenceValue<Key>
//    public let transform: (Key.Value) -> Content
//
//    public init(value: _PreferenceValue<Key>, transform: @escaping (Key.Value) -> Content) {
//        self.value = value
//        self.transform = transform
//    }
//
//    public var body: SomeView {
//        transform(value.value)
//    }
//}
//
//extension PreferenceKey {
//    @inlinable
//    public static func _delay<T>(
//        _ transform: @escaping (_PreferenceValue<Self>) -> T
//    ) -> _DelayedPreferenceView<Self, T> where T: View {
//        _DelayedPreferenceView(transform: transform)
//    }
//}
//
//extension View {
//
//    /// Uses the specified preference value from the view to produce another
//    /// view as an overlay atop the first view.
//    @inlinable
//    public func overlayPreferenceValue<Key, T>(
//        _ key: Key.Type = Key.self,
//        @ViewBuilder _ transform: @escaping (Key.Value) -> T
//    ) -> _DelayedPreferenceView<Key, ModifiedContent<Self, _OverlayModifier<T>>>
//        where Key: PreferenceKey, T: View {
//        Key._delay { pref in self.overlay { transform(pref.value) } }
//    }
//
//    /// Uses the specified preference value from the view to produce another
//    /// view as a background to the first view.
//    @inlinable
//    public func backgroundPreferenceValue<Key, T>(
//        _ key: Key.Type = Key.self,
//        @ViewBuilder _ transform: @escaping (Key.Value) -> T
//    ) -> _DelayedPreferenceView<Key, ModifiedContent<Self, ViewModifiers._Background<T>>>
//        where Key: PreferenceKey, T: View {
//        Key._delay { self.background(transform($0.value)) }
//    }
//}

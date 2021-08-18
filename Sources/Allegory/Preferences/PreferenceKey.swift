////
//// Created by Mike on 8/14/21.
////
//
//public protocol PreferenceKey {
//    associatedtype Value
//    static var defaultValue: Value { get }
//    static func reduce(value: inout Value, nextValue: () -> Value)
//}
//
//public extension PreferenceKey where Self.Value: ExpressibleByNilLiteral {
//    static var defaultValue: Value { nil }
//}
//
//public struct _PreferenceValue<Key> where Key: PreferenceKey {
//    /// Every value the `Key` has had.
//    var valueList: [Key.Value]
//    /// The latest value.
//    public var value: Key.Value {
//        reduce(valueList)
//    }
//
//    func reduce(_ values: [Key.Value]) -> Key.Value {
//        values.reduce(into: Key.defaultValue) { prev, next in
//            Key.reduce(value: &prev) { next }
//        }
//    }
//}
//
//public extension _PreferenceValue {
//    func _force<V>(
//        _ transform: @escaping (Key.Value) -> V
//    ) -> _PreferenceReadingView<Key, V> where V: View {
//        _PreferenceReadingView(value: self, transform: transform)
//    }
//}
//
//public struct _PreferenceStore {
//    /// The backing values of the `_PreferenceStore`.
//    private var values: [String: Any]
//
//    public init(values: [String: Any] = [:]) {
//        self.values = values
//    }
//
//    public func value<Key>(
//        forKey key: Key.Type = Key.self
//    ) -> _PreferenceValue<Key> where Key: PreferenceKey {
//        values[String(reflecting: key)] as? _PreferenceValue<Key>
//            ?? _PreferenceValue(valueList: [Key.defaultValue])
//    }
//
//    public mutating func insert<Key>(
//        _ value: Key.Value,
//        forKey key: Key.Type = Key.self
//    ) where Key: PreferenceKey {
//        let previousValues = self.value(forKey: key).valueList
//        values[String(reflecting: key)] =
//            _PreferenceValue<Key>(valueList: previousValues + [value])
//    }
//
//    public mutating func merge(with other: Self) {
//        self = merging(with: other)
//    }
//
//    public func merging(with other: Self) -> Self {
//        var result = values
//        for (key, value) in other.values {
//            result[key] = value
//        }
//        return .init(values: result)
//    }
//}
//
///// A protocol that allows a `View` to read values from the current
///// `_PreferenceStore`. The key difference between
///// `_PreferenceReadingViewProtocol` and `_PreferenceWritingViewProtocol` is
///// that `_PreferenceReadingViewProtocol` calls `preferenceStore` during the
///// current render, and `_PreferenceWritingViewProtocol` waits until the current
///// render finishes.
//public protocol _PreferenceReadingViewProtocol {
//    func preferenceStore(_ preferenceStore: _PreferenceStore)
//}
//
///// A protocol that allows a `View` to modify values from the current
///// `_PreferenceStore`.
//public protocol _PreferenceWritingViewProtocol {
//    func modifyPreferenceStore(
//        _ preferenceStore: inout _PreferenceStore
//    ) -> SomeView
//}
//
///// A protocol that allows a `ViewModifier` to modify values from the current
///// `_PreferenceStore`.
//public protocol _PreferenceWritingModifierProtocol: ViewModifier
//    where Body == Never {
//
//    func body(
//        _ content: Self.Content,
//        with preferenceStore: inout _PreferenceStore
//    ) -> SomeView
//}
//
//public extension _PreferenceWritingModifierProtocol {
//    func body(content: Content) -> SomeView {
//        content.view
//    }
//}
//
//extension ModifiedContent: _PreferenceWritingViewProtocol
//    where Content: View, Modifier: _PreferenceWritingModifierProtocol {
//
//    public func modifyPreferenceStore(
//        _ preferenceStore: inout _PreferenceStore
//    ) -> SomeView {
//        modifier.body(
//            .init(content, modifier: modifier),
//            with: &preferenceStore
//        )
//    }
//}

//
// Created by Mike on 8/15/21.
//

import Foundation.NSUserDefaults

@usableFromInline
internal class UserDefaultLocation<Value> {
    internal let key: String
    internal let defaultValue: Value
    internal let store: UserDefaults?

    @Environment(\.defaultAppStorageDefaults)
    internal var defaultStore: UserDefaults

    internal func get() -> Value {
        (store ?? defaultStore).value(forKey: key) as? Value ?? defaultValue
    }

    internal func set(_ value: Value) {
        (store ?? defaultStore).set(value, forKey: key)
    }

    @usableFromInline
    internal init(key: String, defaultValue: Value, store: UserDefaults?) {
        self.key = key
        self.defaultValue = defaultValue
        self.store = store
    }
}

@propertyWrapper public struct AppStorage<Value>: DynamicProperty {
    @usableFromInline
    internal var location: UserDefaultLocation<Value>

    public var wrappedValue: Value {
        get {
            location.get()
        }
        nonmutating set {
            location.set(newValue)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

extension AppStorage {
    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == Bool {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == Int {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == Double {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == String {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == URL {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == Data {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value: RawRepresentable, Value.RawValue == Int {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }

    public init(
        wrappedValue: Value,
        _ key: String,
        store: UserDefaults? = nil
    ) where Value: RawRepresentable, Value.RawValue == String {
        location = .init(key: key, defaultValue: wrappedValue, store: store)
    }
}

extension AppStorage where Value: ExpressibleByNilLiteral {
    public init(_ key: String, store: UserDefaults? = nil) where Value == Bool? {
        location = .init(key: key, defaultValue: nil, store: store)
    }

    public init(_ key: String, store: UserDefaults? = nil) where Value == Int? {
        location = .init(key: key, defaultValue: nil, store: store)
    }

    public init(_ key: String, store: UserDefaults? = nil) where Value == Double? {
        location = .init(key: key, defaultValue: nil, store: store)
    }

    public init(_ key: String, store: UserDefaults? = nil) where Value == String? {
        location = .init(key: key, defaultValue: nil, store: store)
    }

    public init(_ key: String, store: UserDefaults? = nil) where Value == URL? {
        location = .init(key: key, defaultValue: nil, store: store)
    }

    public init(_ key: String, store: UserDefaults? = nil) where Value == Data? {
        location = .init(key: key, defaultValue: nil, store: store)
    }

}

extension AppStorage {
    public init<R>(
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == Optional<R>, R: RawRepresentable, R.RawValue == String {
        location = .init(key: key, defaultValue: nil, store: store)
    }

    public init<R>(
        _ key: String,
        store: UserDefaults? = nil
    ) where Value == Optional<R>, R: RawRepresentable, R.RawValue == Int {
        location = .init(key: key, defaultValue: nil, store: store)
    }
}

extension View {

    /// The default store used by `AppStorage` contained within the view.
    ///
    /// If unspecified, the default store for a view hierarchy is
    /// `UserDefaults.standard`, but can be set a to a custom one. For example,
    /// sharing defaults between an app and an extension can override the
    /// default store to one created with `UserDefaults.init(suiteName:_)`.
    ///
    /// - Parameter store: The user defaults to use as the default
    ///   store for `AppStorage`.
    public func defaultAppStorage(
        _ store: UserDefaults
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<UserDefaults>> {
        environment(\.defaultAppStorageDefaults, store)
    }
}

extension Scene {

    /// The default store used by `AppStorage` contained within the scene and
    /// its view content.
    ///
    /// If unspecified, the default store for a view hierarchy is
    /// `UserDefaults.standard`, but can be set a to a custom one. For example,
    /// sharing defaults between an app and an extension can override the
    /// default store to one created with `UserDefaults.init(suiteName:_)`.
    ///
    /// - Parameter store: The user defaults to use as the default
    ///   store for `AppStorage`.
    public func defaultAppStorage(
        _ store: UserDefaults
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<UserDefaults>> {
        environment(\.defaultAppStorageDefaults, store)
    }
}

struct DefaultAppStorageEnvironmentKey: EnvironmentKey {
    static let defaultValue: UserDefaults = .standard
}

extension EnvironmentValues {
    @usableFromInline
    internal var defaultAppStorageDefaults: UserDefaults {
        get {
            self[DefaultAppStorageEnvironmentKey.self]
        }
        set {
            self[DefaultAppStorageEnvironmentKey.self] = newValue
        }
    }
}

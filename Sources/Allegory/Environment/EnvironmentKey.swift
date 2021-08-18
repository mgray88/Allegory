//
// Created by Mike on 7/31/21.
//

/// A key for accessing values in the environment.
///
/// You can create custom environment values by extending the
/// ``EnvironmentValues`` structure with new properties. First declare a new
/// environment key type and specify a value for the required ``defaultValue``
/// property:
///
/// ```swift
/// private struct MyEnvironmentKey: EnvironmentKey {
///     static let defaultValue: String = "Default value"
/// }
/// ```
///
/// The Swift compiler automatically infers the associated ``Value`` type as the
/// type you specify for the default value. Then use the key to define a new
/// environment value property:
///
/// ```swift
/// extension EnvironmentValues {
///     var myCustomValue: String {
///         get { self[MyEnvironmentKey.self] }
///         set { self[MyEnvironmentKey.self] = newValue }
///     }
/// }
/// ```
///
/// Clients of your environment value never use the key directly. Instead, they
/// use the key path of your custom environment value property. To set the
/// environment value for a view and all its subviews, add the
/// ``environment(_:_:)`` view modifier to that view:
///
/// ```swift
/// MyView()
///     .environment(\.myCustomValue, "Another string")
/// ```
///
/// As a convenience, you can also define a dedicated view modifier to apply
/// this environment value:
///
/// ```swift
/// extension View {
///     func myCustomValue(_ myCustomValue: String) -> some View {
///         environment(\.myCustomValue, myCustomValue)
///     }
/// }
/// ```
///
/// This improves clarity at the call site:
///
/// ```swift
/// MyView()
///     .myCustomValue("Another string")
/// ```
///
/// To read the value from inside `MyView` or one of its descendants, use the
/// ``Environment`` property wrapper:
///
/// ```swift
/// struct MyView: View {
///     @Environment(\.myCustomValue) var customValue: String
///
///     var body: some View {
///         Text(customValue) // Displays "Another value".
///     }
/// }
/// ```
public protocol EnvironmentKey {
    /// The associated type representing the type of the environment key's
    /// value.
    associatedtype Value

    /// The default value for the environment key.
    static var defaultValue: Self.Value { get }
}

protocol EnvironmentModifier {
    func modifyEnvironment(_ values: inout EnvironmentValues)
}

public struct _EnvironmentKeyWritingModifier<Value>: ViewModifier, EnvironmentModifier {
    public let keyPath: WritableKeyPath<EnvironmentValues, Value>
    public let value: Value

    public init(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
        self.keyPath = keyPath
        self.value = value
    }

    public typealias Body = Never

    func modifyEnvironment(_ values: inout EnvironmentValues) {
        values[keyPath: keyPath] = value
    }
}

extension View {

    /// Sets the environment value of the specified key path to the given value.
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates the property of the
    ///     ``EnvironmentValues`` structure to update.
    ///   - value: The new value to set for the item specified by `keyPath`.
    /// - Returns: A view that has the given value set in its environment.
    @inlinable
    public func environment<V>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>,
        _ value: V
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<V>> {
        modifier(_EnvironmentKeyWritingModifier(keyPath: keyPath, value: value))
    }
}

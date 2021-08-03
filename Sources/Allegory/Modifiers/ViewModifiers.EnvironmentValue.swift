//
// Created by Mike on 7/31/21.
//

extension ViewModifiers {
    public struct _EnvironmentValue: ViewModifier {
        public let modify: (inout EnvironmentValues) -> Void

        @inlinable
        public init(_ modify: @escaping (inout EnvironmentValues) -> Void) {
            self.modify = modify
        }
    }
}

extension View {
    public typealias ModifiedContentEnvironment = ModifiedContent<Self, ViewModifiers._EnvironmentValue>

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
    ) -> ModifiedContentEnvironment {
        modifier(
            ViewModifiers._EnvironmentValue {
                $0[keyPath: keyPath] = value
            }
        )
    }

    /// Transforms the environment value of the specified key path with the
    /// given function.
    @inlinable
    public func transformEnvironment<V>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>,
        transform: @escaping (inout V) -> Void
    ) -> ModifiedContentEnvironment {
        modifier(
            ViewModifiers._EnvironmentValue {
                transform(&$0[keyPath: keyPath])
            }
        )
    }
}

extension ViewModifiers._EnvironmentValue: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "EnvironmentValue"
        }

        func update(viewModifier: ViewModifiers._EnvironmentValue, context: inout Context) {
            viewModifier.modify(&context.environment)
        }
    }

    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

extension View {

    @inlinable
    public func foregroundColor(
        _ color: Color?
    ) -> ModifiedContentEnvironment {
        environment(\.foregroundColor, color)
    }

//    @inlinable
//    public func zIndex(_ value: Double) -> View {
//        return environment()
//    }

    @inlinable
    public func accentColor(
        _ accentColor: Color?
    ) -> ModifiedContentEnvironment {
        environment(\.accentColor, accentColor)
    }

//    @inlinable
//    public func disabled(_ disabled: Bool) -> ModifiedContentEnvironment {
//        environment(\.isEnabled, !disabled)
//    }

//    @inlinable
//    public func opacity(_ opacity: Double) -> ModifiedContentEnvironment

    @inlinable
    public func font(
        _ font: Font
    ) -> ModifiedContentEnvironment {
        environment(\.font, font)
    }

//    @inlinable
//    public func hidden() -> ModifiedContentEnvironment {
//        environment(\.hidden, true)
//    }

    @inlinable
    public func multilineTextAlignment(
        _ multilineTextAlignment: TextAlignment
    ) -> ModifiedContentEnvironment {
        environment(\.multilineTextAlignment, multilineTextAlignment)
    }

    @inlinable
    public func truncationMode(
        _ truncationMode: Text.TruncationMode
    ) -> ModifiedContentEnvironment {
        environment(\.truncationMode, truncationMode)
    }

    @inlinable
    public func lineSpacing(
        _ lineSpacing: Double
    ) -> ModifiedContentEnvironment {
        environment(\.lineSpacing, lineSpacing)
    }

    @inlinable
    public func allowsTightening(
        _ allowsTightening: Bool
    ) -> ModifiedContentEnvironment {
        environment(\.allowsTightening, allowsTightening)
    }

    @inlinable
    public func lineLimit(
        _ lineLimit: Int?
    ) -> ModifiedContentEnvironment {
        environment(\.lineLimit, lineLimit)
    }

    @inlinable
    public func minimumScaleFactor(
        _ minimumScaleFactor: Double
    ) -> ModifiedContentEnvironment {
        environment(\.minimumScaleFactor, minimumScaleFactor)
    }
}

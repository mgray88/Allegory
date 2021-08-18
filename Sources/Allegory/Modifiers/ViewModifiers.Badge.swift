//
// Created by Mike on 8/9/21.
//

extension ViewModifiers {
    public struct _Badge: ViewModifier {
    }
}

extension View {

    /// Generates a badge for the view from an integer value.
    ///
    /// This modifier automatically formats the integer with a formatter
    /// appropriate for the current ``Environment``.
    ///
    /// Badges are only displayed in list rows and iOS tab bars.
    ///
    /// The following example shows a List with a badge on one of the rows:
    ///
    ///     List {
    ///         Text("Recents")
    ///             .badge(10)
    ///         Text("Favorites")
    ///     }
    ///
    /// - Parameter count: An integer value to display in the badge.
    ///   Set the value to zero to hide the badge.
    public func badge(
        _ count: Int
    ) -> ModifiedContent<Self, ViewModifiers._Badge> {
        TODO()
    }

    /// Generates a badge for the view from a text view.
    ///
    /// Badges are only displayed in list rows and tab bars.
    ///
    /// Use a badge to convey optional, supplementary information about a
    /// view. Keep the contents of the badge as short as possible.
    ///
    /// - Parameter label: An optional ``Text`` view to display as a badge.
    ///   Set the value to `nil` to hide the badge.
    public func badge(
        _ label: Text?
    ) -> ModifiedContent<Self, ViewModifiers._Badge> {
        TODO()
    }

    /// Generates a badge for the view from a string.
    ///
    /// Badges are only displayed in list rows and tab bars.
    ///
    /// Use a badge to convey optional, supplementary information about a
    /// view. Keep the contents of the badge as short as possible.
    ///
    /// This modifier creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:)-9d1g4``.
    ///
    /// - Parameter label: An optional string to display as a badge.
    ///   Set the value to `nil` to hide the badge.
    public func badge<S>(
        _ label: S?
    ) -> ModifiedContent<Self, ViewModifiers._Badge> where S: StringProtocol {
        TODO()
    }
}

extension ViewModifiers._Badge: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Badge"
        }

        func update(
            viewModifier: ViewModifiers._Badge,
            context: inout Context
        ) {}

        func render(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

//
// Created by Mike on 8/3/21.
//

extension ViewModifiers {
    public struct _ProgressViewStyle<Style>: ViewModifier
    where Style: ProgressViewStyle {
        public let style: Style

        @inlinable
        public init(style: Style) {
            self.style = style
        }
    }
}

extension View {
    /// Sets the style for progress views in this view.
    ///
    /// For example, the following code creates a progress view that uses the
    /// "circular" style:
    ///
    ///     ProgressView()
    ///         .progressViewStyle(CircularProgressViewStyle())
    ///
    /// - Parameter style: The progress view style to use for this view.
    public func progressViewStyle<S>(
        _ style: S
    ) -> ModifiedContent<Self, ViewModifiers._ProgressViewStyle<S>>
        where S : ProgressViewStyle {
        modifier(.init(style: style))
    }
}

extension ViewModifiers._ProgressViewStyle: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "ProgressViewStyle"
        }

        func update(
            viewModifier: ViewModifiers._ProgressViewStyle<Style>,
            context: inout Context
        ) {
            context.environment._progressViewStyle = viewModifier.style
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

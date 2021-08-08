//
// Created by Mike on 8/1/21.
//

extension ViewModifiers {
    public struct _EdgesIgnoringSafeArea: ViewModifier {
        public let edges: Edge.Set

        @inlinable
        public init(edges: Edge.Set) {
            self.edges = edges
        }
    }
}

extension View {
    /// Changes the view's proposed area to extend outside the screen's safe
    /// areas.
    ///
    /// Use `edgesIgnoringSafeArea(_:)` to change the area proposed for this
    /// view so that — were the proposal accepted — this view could extend
    /// outside the safe area to the bounds of the screen for the specified
    /// edges.
    ///
    /// For example, you can propose that a text view ignore the safe area's top
    /// inset:
    ///
    /// ```swift
    /// VStack {
    ///     Text("This text is outside of the top safe area.")
    ///         .edgesIgnoringSafeArea([.top])
    ///         .border(Color.purple)
    ///     Text("This text is inside VStack.")
    ///         .border(Color.yellow)
    /// }
    /// .border(Color.gray)
    /// ```
    ///
    /// Depending on the surrounding view hierarchy, TOCUIKit may not honor an
    /// `edgesIgnoringSafeArea(_:)` request. This can happen, for example, if
    /// the view is inside a container that respects the screen's safe area. In
    /// that case you may need to apply `edgesIgnoringSafeArea(_:)` to the
    /// container instead.
    ///
    /// - Parameter edges: The set of the edges in which to expand the size
    ///   requested for this view.
    /// - Returns: A view that may extend outside of the screen’s safe area on
    ///   the edges specified by `edges`.
    @inlinable
    public func edgesIgnoringSafeArea(
        _ edges: Edge.Set
    ) -> ModifiedContent<Self, ViewModifiers._EdgesIgnoringSafeArea> {
        modifier(ViewModifiers._EdgesIgnoringSafeArea(edges: edges))
    }
}

extension ViewModifiers._EdgesIgnoringSafeArea: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "EdgesIgnoringSafeArea"
        }

        var viewModifier: ViewModifiers._EdgesIgnoringSafeArea!

        func update(
            viewModifier: ViewModifiers._EdgesIgnoringSafeArea,
            context: inout Context
        ) {
            self.viewModifier = viewModifier
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            node.render(
                in: container,
                bounds: bounds.unsafe(edges: viewModifier.edges),
                pass: pass
            )
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

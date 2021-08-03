//
// Created by Mike on 8/1/21.
//

extension ViewModifiers {
    public struct _LayoutPriority: ViewModifier {
        public let value: Double

        @inlinable
        public init(_ value: Double) {
            self.value = value
        }
    }
}

extension View {
    /// Sets the priority by which a parent layout should apportion space to
    /// this child.
    ///
    /// Views typically have a default priority of `0` which causes space to be
    /// apportioned evenly to all sibling views. Raising a view's layout
    /// priority encourages the higher priority view to shrink later when the
    /// group is shrunk and stretch sooner when the group is stretched.
    ///
    /// ```swift
    /// HStack {
    ///     Text("This is a moderately long string.")
    ///         .font(.largeTitle)
    ///         .border(Color.gray)
    ///
    ///     Spacer()
    ///
    ///     Text("This is a higher priority string.")
    ///         .font(.largeTitle)
    ///         .layoutPriority(1)
    ///         .border(Color.gray)
    /// }
    /// ```
    ///
    /// In the example above, the first ``Text`` element has the default
    /// priority `0` which causes its view to shrink dramatically due to the
    /// higher priority of the second ``Text`` element, even though all of their
    /// other attributes (font, font size and character count) are the same.
    ///
    /// A parent layout offers the child views with the highest layout priority
    /// all the space offered to the parent minus the minimum space required for
    /// all its lower-priority children.
    ///
    /// - Parameter value: The priority by which a parent layout apportions
    ///   space to the child.
    @inlinable
    public func layoutPriority(
        _ value: Double
    ) -> ModifiedContent<Self, ViewModifiers._LayoutPriority> {
        modifier(ViewModifiers._LayoutPriority(value))
    }
}

extension ViewModifiers._LayoutPriority: UIKitNodeModifierResolvable {
    internal class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "LayoutPriority"
        }

        var viewModifier: ViewModifiers._LayoutPriority!

        func update(
            viewModifier: ViewModifiers._LayoutPriority,
            context: inout Context
        ) {
            self.viewModifier = viewModifier
        }

        var layoutPriority: Double {
            viewModifier.value
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

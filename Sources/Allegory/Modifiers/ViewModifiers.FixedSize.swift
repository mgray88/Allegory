//
// Created by Mike on 8/1/21.
//

extension ViewModifiers {
    public struct _FixedSize: ViewModifier {
        public let horizontal: Bool
        public let vertical: Bool

        @inlinable
        public init(horizontal: Bool, vertical: Bool) {
            self.horizontal = horizontal
            self.vertical = vertical
        }
    }
}

extension View {
    /// Fixes this view at its ideal size in the specified dimensions.
    ///
    /// This function behaves like ``fixedSize()``, except with
    /// `fixedSize(horizontal:vertical:)` the fixing of the axes can be
    /// optionally specified in one or both dimensions.
    ///
    /// - Parameters:
    ///   - horizontal: A Boolean value that indicates whether to fix the width
    ///     of the view.
    ///   - vertical: A Boolean value that indicates whether to fix the height
    ///     of the view.
    /// - Returns: A view that fixes this view at its ideal size in the
    ///   dimensions specified by `horizontal` and `vertical`.
    @inlinable
    public func fixedSize(
        horizontal: Bool = true,
        vertical: Bool = false
    ) -> ModifiedContent<Self, ViewModifiers._FixedSize> {
        modifier(
            ViewModifiers._FixedSize(
                horizontal: horizontal,
                vertical: vertical
            )
        )
    }

    /// Fixes this view at its ideal size.
    ///
    /// During the layout of the view hierarchy, each view proposes a size to
    /// each child view it contains. If the child view doesn't need a fixed size
    /// it can accept and conform to the size offered by the parent.
    ///
    /// The `fixedSize()` modifier can be used to create a view that maintains
    /// the _ideal size_ of its children in both dimensions
    ///
    /// You can think of `fixedSize()` as the creation of a _counter proposal_
    /// to the view size proposed to a view by its parent. The ideal size of a
    /// view, and the specific effects of `fixedSize()` depends on the
    /// particular view and how you have configured it.
    ///
    /// To create a view that fixes the view's size in either the horizontal or
    /// vertical dimensions, see ``fixedSize(horizontal:vertical:)``.
    ///
    /// - Returns: A view that fixes this view at its ideal size.
    @inlinable
    public func fixedSize() -> ModifiedContent<Self, ViewModifiers._FixedSize> {
        fixedSize(horizontal: true, vertical: true)
    }
}

extension ViewModifiers._FixedSize: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "FixedSize"
        }

        var viewModifier: ViewModifiers._FixedSize!

        func update(viewModifier: ViewModifiers._FixedSize, context: inout Context) {
            self.viewModifier = viewModifier
        }

        func layoutSize(
            fitting targetSize: CGSize,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) -> CGSize {
            var size = targetSize
            if viewModifier.horizontal {
                size.width = 0
            }
            if viewModifier.vertical {
                size.height = 0
            }
            return node.layoutSize(fitting: size, pass: pass)
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

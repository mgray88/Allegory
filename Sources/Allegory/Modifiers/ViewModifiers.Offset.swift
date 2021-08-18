//
// Created by Mike on 7/31/21.
//

extension ViewModifiers {
    public struct _Offset: ViewModifier {
        public let offset: CGSize

        @inlinable
        public init(_ offset: CGSize) {
            self.offset = offset
        }
    }
}

extension View {
    /// Offset this view by the horizontal and vertical amount specified in the
    /// offset parameter.
    ///
    /// Use `offset(_:)` to shift the displayed contents by the amount specified
    /// in the `offset` parameter.
    ///
    /// - Parameter offset: The distance to offset this view.
    /// - Returns: A view that offsets this view by `offset`.
//    @inlinable
//    public func offset(
//        _ offset: CGSize
//    ) -> ModifiedContent<Self, ViewModifiers._Offset> {
//        modifier(ViewModifiers._Offset(offset))
//    }

    /// Offset this view by the specified horizontal and vertical distances.
    ///
    /// Use `offset(x:y:)` to shift the displayed contents by the amount
    /// specified in the `x` and `y` parameters.
    ///
    /// - Parameters:
    ///   - x: The horizontal distance to offset this view.
    ///   - y: The vertical distance to offset this view.
    /// - Returns: A view that offsets this view by `x` and `y`.
//    @inlinable
//    public func offset(
//        x: CGFloat = 0,
//        y: CGFloat = 0
//    ) -> ModifiedContent<Self, ViewModifiers._Offset> {
//        offset(CGSize(width: x, height: y))
//    }
}

extension ViewModifiers._Offset: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Offset"
        }

        var viewModifier: ViewModifiers._Offset!

        func update(
            viewModifier: ViewModifiers._Offset,
            context: inout Context
        ) {
            self.viewModifier = viewModifier
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            let bounds = bounds.offset(
                dx: viewModifier.offset.width,
                dy: viewModifier.offset.height
            )
            node.render(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

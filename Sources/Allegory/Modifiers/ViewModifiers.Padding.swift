//
// Created by Mike on 7/30/21.
//

import Foundation

extension ViewModifiers {
    public struct _Padding: ViewModifier, Layout {
        internal let top: Double?
        internal let bottom: Double?
        internal let leading: Double?
        internal let trailing: Double?

        internal init(
            top: Double?, bottom: Double?, leading: Double?, trailing: Double?
        ) {
            self.top = top
            self.bottom = bottom
            self.leading = leading
            self.trailing = trailing
        }

        internal init(_ insets: EdgeInsets) {
            (top, bottom, leading, trailing) =
                (insets.top, insets.bottom, insets.leading, insets.trailing)
        }

        internal init(_ insets: Double?) {
            (top, bottom, leading, trailing) = (insets, insets, insets, insets)
        }

        internal func layoutAlgorithm(
            nodes: [LayoutNode],
            env: EnvironmentValues
        ) -> LayoutAlgorithm {
            LayoutAlgorithms.Padding(
                padding: self,
                node: nodes.first!,
                defaultPadding: env.padding
            )
        }
    }
}

extension View {
    /// Pads this view using the edges and padding amount you specify.
    ///
    /// - Parameter insets: The edges and amounts to inset.
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    public func padding(
        _ insets: EdgeInsets
    ) -> ModifiedContent<Self, ViewModifiers._Padding> {
        modifier(.init(insets))
    }

    /// Pads the view along all edges by the specified amount.
    ///
    /// - Parameter insets: The amount to pad this view on each edge.
    /// - Returns: A view that pads this view by the amount you specify.
    public func padding(
        _ insets: Double? = nil
    ) -> ModifiedContent<Self, ViewModifiers._Padding> {
        modifier(.init(insets))
    }

    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    ///
    /// - Parameters:
    ///   - edges: The set of edges along which to pad this view. The default is
    ///     ``Edge.Set.all``.
    ///   - length: The amount to inset this view on the specified edges. If you
    ///     set the value to `nil`, TOCUIKit uses the system-default amount. The
    ///     default is `nil`.
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    public func padding(
        _ edges: Edge.Set = .all,
        _ length: Double? = nil
    ) -> ModifiedContent<Self, ViewModifiers._Padding> {
        modifier(
            .init(
                top: edges.contains(.top) ? length : 0,
                bottom: edges.contains(.bottom) ? length : 0,
                leading: edges.contains(.leading) ? length : 0,
                trailing: edges.contains(.trailing) ? length : 0
            )
        )
    }
}

extension ViewModifiers._Padding: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Padding"
        }

        var viewModifier: ViewModifiers._Padding!
        var environment: EnvironmentValues!

        func update(viewModifier: ViewModifiers._Padding, context: inout Context) {
            self.viewModifier = viewModifier
            self.environment = context.environment
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
            viewModifier.layoutAlgorithm(nodes: [node], env: environment)
                .layoutSize(fitting: proposedSize, pass: pass)
                .idealSize
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            let geometry = viewModifier
                .layoutAlgorithm(nodes: [node], env: environment)
                .layoutSize(fitting: bounds.proposedSize, pass: pass)
            node.layout(
                in: container,
                bounds: bounds.update(
                    to: geometry.frames[0]
                        .offsetBy(dx: bounds.rect.minX, dy: bounds.rect.minY)
                ),
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

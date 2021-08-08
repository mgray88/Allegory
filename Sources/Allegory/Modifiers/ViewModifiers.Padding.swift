//
// Created by Mike on 7/30/21.
//

import Foundation

extension ViewModifiers {
    public struct _Padding: ViewModifier {
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

        private var insets: EdgeInsets = .zero
        private var cache = GeometryCache()

        func update(viewModifier: ViewModifiers._Padding, context: inout Context) {
            let defaultPadding = context.environment.padding
            insets = EdgeInsets(
                top: viewModifier.top ?? defaultPadding,
                leading: viewModifier.leading ?? defaultPadding,
                bottom: viewModifier.bottom ?? defaultPadding,
                trailing: viewModifier.trailing ?? defaultPadding
            )
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
            if let geometry = cache.geometry(for: pass, size: proposedSize.orDefault) {
                return geometry.idealSize
            }
            let nodeSize = node.size(
                fitting: proposedSize.inset(by: insets),
                pass: pass
            )
            let idealSize = CGSize(
                width: nodeSize.width + CGFloat(insets.leading + insets.trailing),
                height: nodeSize.height + CGFloat(insets.top + insets.bottom)
            )
            cache.update(
                pass: pass,
                size: proposedSize.orDefault,
                geometry: ContentGeometry(idealSize: idealSize, frames: [])
            )
            return idealSize
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            let size = size(
                fitting: bounds.proposedSize,
                pass: pass,
                node: node
            )
            let rect = CGRect(
                x: insets.leading,
                y: insets.top,
                width: Double(size.width) - insets.leading - insets.trailing,
                height: Double(size.height) - insets.top - insets.bottom
            )
            node.render(
                in: container,
                bounds: bounds.update(
                    to: rect
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

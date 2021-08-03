//
// Created by Mike on 8/1/21.
//

import UIKit

extension ViewModifiers {
    public struct _FlexFrame: ViewModifier, Layout {
        public let minWidth: CGFloat?
        public let idealWidth: CGFloat?
        public let maxWidth: CGFloat?

        public let minHeight: CGFloat?
        public let idealHeight: CGFloat?
        public let maxHeight: CGFloat?

        public let alignment: Alignment

        @inlinable
        public init(
            minWidth: CGFloat?,
            idealWidth: CGFloat?,
            maxWidth: CGFloat?,
            minHeight: CGFloat?,
            idealHeight: CGFloat?,
            maxHeight: CGFloat?,
            alignment: Alignment
        ) {
            self.minWidth = minWidth
            self.idealWidth = idealWidth
            self.maxWidth = maxWidth
            self.minHeight = minHeight
            self.idealHeight = idealHeight
            self.maxHeight = maxHeight
            self.alignment = alignment
        }

        internal func layoutAlgorithm(
            nodes: [LayoutNode],
            env: EnvironmentValues
        ) -> LayoutAlgorithm {
            LayoutAlgorithms.FlexFrame(flexFrame: self, node: nodes.first!)
        }
    }
}

extension View {
    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    ///
    ///
    ///
    /// - Parameters:
    ///   - minWidth: The minimum width of the resulting frame.
    ///   - idealWidth: The ideal width of the resulting frame.
    ///   - maxWidth: The maximum width of the resulting frame.
    ///   - minHeight: The minimum height of the resulting frame.
    ///   - idealHeight: The ideal height of the resulting frame.
    ///   - maxHeight: The maximum height of the resulting frame.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    /// - Returns: A view with flexible dimensions given by the call's `non-nil`
    ///   parameters.
    @inlinable
    public func frame(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> ModifiedContent<Self, ViewModifiers._FlexFrame> {
        modifier(
            ViewModifiers._FlexFrame(
                minWidth: minWidth,
                idealWidth: idealWidth,
                maxWidth: maxWidth,
                minHeight: minHeight,
                idealHeight: idealHeight,
                maxHeight: maxHeight,
                alignment: alignment
            )
        )
    }
}

extension ViewModifiers._FlexFrame: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "FlexFrame"
        }

        var viewModifier: ViewModifiers._FlexFrame!

        func update(viewModifier: ViewModifiers._FlexFrame, context: inout Context) {
            self.viewModifier = viewModifier
        }

        func layoutSize(fitting targetSize: CGSize, pass: LayoutPass, node: SomeUIKitNode) -> CGSize {
            LayoutAlgorithms
                .FlexFrame(flexFrame: viewModifier, node: node, screenScale: UIScreen.main.scale)
                .contentLayout(fittingSize: targetSize, pass: pass)
                .idealSize
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass, node: SomeUIKitNode) {
            let geometry = LayoutAlgorithms
                .FlexFrame(flexFrame: viewModifier, node: node, screenScale: UIScreen.main.scale)
                .contentLayout(fittingSize: bounds.size, pass: pass)
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

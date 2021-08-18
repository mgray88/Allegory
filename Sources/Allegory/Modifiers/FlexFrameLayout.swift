//
// Created by Mike on 8/1/21.
//

import UIKit

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
    ) -> ModifiedContent<Self, _FlexFrameLayout> {
        func areInNondecreasingOrder(
            _ min: CGFloat?, _ ideal: CGFloat?, _ max: CGFloat?
        ) -> Bool {
            let min = min ?? -.infinity
            let ideal = ideal ?? min
            let max = max ?? ideal
            return min <= ideal && ideal <= max
        }

        if !areInNondecreasingOrder(minWidth, idealWidth, maxWidth)
               || !areInNondecreasingOrder(minHeight, idealHeight, maxHeight)
        {
            // TODO
//            os_log(
//                .fault, log: Log.runtimeIssuesLog,
//                "Contradictory frame constraints specified.")
        }

        return modifier(
            _FlexFrameLayout(
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

public struct _FlexFrameLayout {
    internal let minWidth: CGFloat?
    internal let idealWidth: CGFloat?
    internal let maxWidth: CGFloat?
    internal let minHeight: CGFloat?
    internal let idealHeight: CGFloat?
    internal let maxHeight: CGFloat?
    internal let alignment: Alignment

    @_LayoutState
    internal var childSize: CGSize = .zero

    @usableFromInline
    internal init(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
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
    public typealias AnimatableData = EmptyAnimatableData
    public typealias Body = Never
}

extension _FlexFrameLayout: Animatable {}

extension _FlexFrameLayout: ViewModifier {}

extension _FlexFrameLayout: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "FlexFrame"
        }

        var frame: _FlexFrameLayout!
        var environment: EnvironmentValues!

        func update(viewModifier: _FlexFrameLayout, context: inout Context) {
            self.frame = viewModifier
            self.environment = context.environment
        }

        func size(
            fitting proposedSize: ProposedSize,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) -> CGSize {
            frame.size(fitting: proposedSize, for: node)
        }

        func render(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {
            node.render(
                in: container,
                bounds: frame.childSize.aligned(in: bounds, frame.alignment),
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

extension _FlexFrameLayout {
    fileprivate func size(
        fitting proposed: ProposedSize,
        for node: SomeUIKitNode
    ) -> CGSize {
        var proposedSize = ProposedSize(
            width: proposed.width ?? idealWidth,
            height: proposed.height ?? idealHeight
        ).orDefault

        if let minWidth = minWidth, minWidth > proposedSize.width {
            proposedSize.width = minWidth
        }
        if let maxWidth = maxWidth, maxWidth < proposedSize.width {
            proposedSize.width = maxWidth
        }
        if let minHeight = minHeight, minHeight > proposedSize.height {
            proposedSize.height = minHeight
        }
        if let maxHeight = maxHeight, maxHeight < proposedSize.height {
            proposedSize.height = maxHeight
        }

        var size = node.size(
            fitting: ProposedSize(proposedSize),
            pass: LayoutPass()
        )
        size.width = clamp(
            proposedSize.width,
            min: minWidth ?? size.width,
            max: maxWidth ?? size.width
        )
        size.height = clamp(
            proposedSize.height,
            min: minHeight ?? size.height,
            max: maxHeight ?? size.height
        )

        self.childSize = size
        return size
    }
}

private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    Swift.min(Swift.max(value, min), max)
}

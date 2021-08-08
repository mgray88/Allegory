//
// Created by Mike on 8/7/21.
//

extension ViewModifiers {
    public struct _AlignmentGuide: ViewModifier {
        public let compute: (ViewDimensions) -> CGFloat

        @inlinable
        public init(compute: @escaping (ViewDimensions) -> CGFloat) {
            self.compute = compute
        }
    }
}

extension View {
    @inlinable
    public func alignmentGuide(
        _ g: VerticalAlignment,
        computeValue: @escaping (ViewDimensions) -> CGFloat
    ) -> ModifiedContent<Self, ViewModifiers._AlignmentGuide> {
        modifier(.init(compute: computeValue))
    }
}

extension ViewModifiers._AlignmentGuide: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "AlignmentGuide"
        }

        func update(
            viewModifier: ViewModifiers._AlignmentGuide,
            context: inout Context
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

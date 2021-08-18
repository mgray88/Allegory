//
// Created by Mike on 7/31/21.
//

import Foundation

/// A flexible space that expands along the major axis of its containing stack
/// layout, or on both axes if not contained in a stack.
public struct Spacer: View, Equatable {

    public typealias Body = Swift.Never

    /// The minimum length this spacer can be shrunk to, along the axis or axes
    /// of expansion.
    ///
    /// If `nil`, the system default spacing between views is used.
    public let minLength: Double?

    @inlinable
    public init(minLength: Double? = nil) {
        self.minLength = minLength
    }
}

extension Spacer: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "Spacer"
        }

        var view: Spacer!
        var context: Context!

        var isSpacer: Bool {
            true
        }

        var minLength: CGFloat {
            CGFloat(view.minLength ?? context.environment.padding)
        }

        func update(view: Spacer, context: Context) {
            self.view = view
            self.context = context
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            let proposed = proposedSize.orMax
            switch context.environment._layoutAxis {
            case .horizontal:
                return CGSize(width: max(minLength, proposed.width), height: 0)

            case .vertical:
                return CGSize(width: 0, height: max(minLength, proposed.height))

            default:
                // TODO: How is the spacer supposed to handle ZStack?
                return CGSize(width: minLength, height: minLength)
            }
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

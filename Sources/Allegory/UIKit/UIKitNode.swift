//
// Created by Mike on 7/29/21.
//

import Foundation

public struct AnyUIKitNode {
    internal let node: SomeUIKitNode

    internal init(_ node: SomeUIKitNode) {
        self.node = node
    }
}

internal protocol SomeUIKitNode: LayoutNode {
    var hierarchyIdentifier: String { get }
    var isSpacer: Bool { get }
    var layoutPriority: Double { get }
    func update(view: SomeView, context: Context)
    func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize
    func layout(in container: Container, bounds: Bounds, pass: LayoutPass)
}

internal protocol UIKitNode: SomeUIKitNode {
    associatedtype View: SomeView

    func update(view: View, context: Context)
}

extension SomeUIKitNode {
    internal var isSpacer: Bool {
        false
    }

    internal var layoutPriority: Double {
        0
    }
}

extension UIKitNode {
    internal func update(view: SomeView, context: Context) {
        update(view: view as! View, context: context)
    }
}

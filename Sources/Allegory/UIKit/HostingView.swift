//
// Created by Mike on 7/29/21.
//

import Foundation
import UIKit

open class HostingView: ContainerView {

    private class Renderer: Allegory.Renderer {

        weak var hostingView: HostingView?

        init(hostingView: HostingView? = nil) {
            self.hostingView = hostingView
        }

        func setNeedsRendering() {
            hostingView?.setNeedsRendering()
        }
    }

    public var context: Context {
        didSet {
            context.rendered = Renderer(hostingView: self)
        }
    }

    public private(set) var view: SomeView

    private var node: SomeUIKitNode

    private var previousBounds: CGRect? = nil

    private var layoutPass = LayoutPass()

    public init(rootView: SomeView, context: Context = Context(), cachedNode: AnyUIKitNode? = nil) {
        let renderer = Renderer()
        var context = context
        context.rendered = renderer
        self.view = rootView
        self.context = context
        self.node = cachedNode?.node ?? rootView.resolve(context: context, cachedNode: nil)
        super.init(frame: .zero)
        renderer.hostingView = self
    }

    public func update(rootView: SomeView, resolvedNode: AnyUIKitNode? = nil) {
        self.view = rootView
        self.node = resolvedNode?.node ?? view.resolve(context: context, cachedNode: nil)
        self.setNeedsRendering()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let bounds: CGRect
        if #available(iOS 11.0, *) {
            bounds = self.safeAreaLayoutGuide.layoutFrame
        } else {
            bounds = self.bounds
        }
        if previousBounds != bounds {
            previousBounds = bounds
            let container = Container(view: self, viewController: parentViewController!)
            container.view.replaceSubnodes {
                node.layout(in: container, bounds: layoutBounds, pass: layoutPass)
            }
        }
    }

    var layoutBounds: Bounds {
        if #available(iOS 11.0, *) {
            return Bounds(rect: bounds.inset(by: safeAreaInsets), safeAreaInsets: .init(safeAreaInsets))
        } else {
            return Bounds(rect: bounds, safeAreaInsets: .zero)
        }
    }

    open func layoutSize(fitting size: CGSize) -> CGSize {
        node.layoutSize(fitting: size, pass: layoutPass)
    }

    open func setNeedsRendering() {
        previousBounds = nil
        layoutPass = .init()
        setNeedsLayout()
        superview?.setNeedsLayout()
    }
}

private extension UIResponder {

    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
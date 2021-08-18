//
// Created by Mike on 7/31/21.
//

/// A container view that defines its content as a function of its own size and
/// coordinate space.
///
/// This view returns a flexible preferred size to its parent layout.
public struct GeometryReader<Content>: View where Content: View {
    public typealias Body = Swift.Never

    public var content: (GeometryProxy) -> Content
    public var alignment: Alignment = .center

    public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }
}

extension GeometryReader {
    public init(
        alignment: Alignment,
        @ViewBuilder content: @escaping (GeometryProxy) -> Content
    ) {
        self.init(content: content)
        self.alignment = alignment
    }
}

extension GeometryReader: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "GeometryReader<***>"
        }

        var view: GeometryReader<Content>?
        var context: Context?

        var node: SomeUIKitNode?

        func update(view: GeometryReader<Content>, context: Context) {
            self.view = view
            self.context = context
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            proposedSize.orDefault
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            guard let view = view, let context = context else { fatalError() }
            let unsafeRect = bounds.unsafeRect()
            let proxy = GeometryProxy(
                size: unsafeRect.size,
                safeAreaInsets: bounds.safeAreaInsets,
                getFrame: { space in
                    switch space {
                    case .local:
                        return CGRect(x: 0, y: 0, width: unsafeRect.width, height: unsafeRect.height)

                    case .global:
                        return unsafeRect

                    case .named:
                        notSupported()
                    }
                }
            )
            let content = view.content(proxy)
            node = content.resolve(context: context, cachedNode: node)
            let size = node!.size(fitting: bounds.proposedSize, pass: pass)
            node!.render(
                in: container,
                bounds: size.aligned(in: bounds, view.alignment),
                pass: pass
            )
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

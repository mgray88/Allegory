//
// Created by Mike on 8/3/21.
//

extension ViewModifiers {
    public struct _AspectRatio: ViewModifier {
        public let aspectRatio: CGFloat?
        public let contentMode: ContentMode

        @inlinable
        public init(_ aspectRatio: CGFloat?, contentMode: ContentMode) {
            self.aspectRatio = aspectRatio
            self.contentMode = contentMode
        }
    }
}

extension View {
    /// Constrains this view's dimensions to the specified aspect ratio.
    ///
    /// Use `aspectRatio(_:contentMode:)` to constrain a view's dimensions to an
    /// aspect ratio specified by a
    /// <doc://com.apple.documentation/documentation/CoreGraphics/CGFloat> using
    /// the specified content mode.
    ///
    /// If this view is resizable, the resulting view will have `aspectRatio` as
    /// its aspect ratio. In this example, the purple ellipse has a 3:4
    /// width-to-height ratio, and scales to fit its frame:
    ///
    ///     Ellipse()
    ///         .fill(Color.purple)
    ///         .aspectRatio(0.75, contentMode: .fit)
    ///         .frame(width: 200, height: 200)
    ///         .border(Color(white: 0.75))
    ///
    /// - Parameters:
    ///   - aspectRatio: The ratio of width to height to use for the resulting
    ///     view. Use `nil` to maintain the current aspect ratio in the
    ///     resulting view.
    ///   - contentMode: A flag that indicates whether this view fits or fills
    ///     the parent context.
    ///
    /// - Returns: A view that constrains this view's dimensions to the aspect
    ///   ratio of the given size using `contentMode` as its scaling algorithm.
    @inlinable
    public func aspectRatio(
        _ aspectRatio: CGFloat? = nil,
        contentMode: ContentMode
    ) -> ModifiedContent<Self, ViewModifiers._AspectRatio> {
        modifier(
            ViewModifiers._AspectRatio(aspectRatio, contentMode: contentMode)
        )
    }

    /// Constrains this view's dimensions to the aspect ratio of the given size.
    ///
    /// Use `aspectRatio(_:contentMode:)` to constrain a view's dimensions to
    /// an aspect ratio specified by a
    /// <doc://com.apple.documentation/documentation/CoreGraphics/CGSize>.
    ///
    /// If this view is resizable, the resulting view uses `aspectRatio` as its
    /// own aspect ratio. In this example, the purple ellipse has a 3:4
    /// width-to-height ratio, and scales to fill its frame:
    ///
    ///     Ellipse()
    ///         .fill(Color.purple)
    ///         .aspectRatio(CGSize(width: 3, height: 4), contentMode: .fill)
    ///         .frame(width: 200, height: 200)
    ///         .border(Color(white: 0.75))
    ///
    /// - Parameters:
    ///   - aspectRatio: A size that specifies the ratio of width to height to
    ///     use for the resulting view.
    ///   - contentMode: A flag indicating whether this view should fit or fill
    ///     the parent context.
    ///
    /// - Returns: A view that constrains this view's dimensions to
    ///   `aspectRatio`, using `contentMode` as its scaling algorithm.
    @inlinable
    public func aspectRatio(
        _ aspectRatio: CGSize,
        contentMode: ContentMode
    ) -> ModifiedContent<Self, ViewModifiers._AspectRatio> {
        modifier(
            ViewModifiers._AspectRatio(
                aspectRatio.width / aspectRatio.height,
                contentMode: contentMode
            )
        )
    }

    /// Scales this view to fit its parent.
    ///
    /// Use `scaledToFit()` to scale this view to fit its parent, while
    /// maintaining the view's aspect ratio as the view scales.
    ///
    ///     Circle()
    ///         .fill(Color.pink)
    ///         .scaledToFit()
    ///         .frame(width: 300, height: 150)
    ///         .border(Color(white: 0.75))
    ///
    /// This method is equivalent to calling
    /// ``View/aspectRatio(_:contentMode:)-5ehx6`` with a `nil` aspectRatio and
    /// a content mode of ``ContentMode/fit``.
    ///
    /// - Returns: A view that scales this view to fit its parent, maintaining
    ///   this view's aspect ratio.
    @inlinable
    public func scaledToFit()
            -> ModifiedContent<Self, ViewModifiers._AspectRatio> {
        aspectRatio(contentMode: .fit)
    }

    /// Scales this view to fill its parent.
    ///
    /// Use `scaledToFill()` to scale this view to fill its parent, while
    /// maintaining the view's aspect ratio as the view scales:
    ///
    ///     Circle()
    ///         .fill(Color.pink)
    ///         .scaledToFill()
    ///         .frame(width: 300, height: 150)
    ///         .border(Color(white: 0.75))
    ///
    /// ![A screenshot of pink circle scaled to fill its
    /// frame.](SwiftUI-View-scaledToFill-1.png)
    ///
    /// This method is equivalent to calling
    /// ``View/aspectRatio(_:contentMode:)-5ehx6`` with a `nil` aspectRatio and
    /// a content mode of ``ContentMode/fill``.
    ///
    /// - Returns: A view that scales this view to fill its parent, maintaining
    ///   this view's aspect ratio.
    @inlinable
    public func scaledToFill()
            -> ModifiedContent<Self, ViewModifiers._AspectRatio> {
        aspectRatio(contentMode: .fill)
    }
}

extension ViewModifiers._AspectRatio: UIKitNodeModifierResolvable {

    private class Node: UIKitNodeModifier {

        var hierarchyIdentifier: String {
            "AspectRatio"
        }

        var viewModifier: ViewModifiers._AspectRatio!

        func update(
            viewModifier: ViewModifiers._AspectRatio,
            context: inout Context
        ) {
            self.viewModifier = viewModifier
        }

        func layoutSize(
            fitting targetSize: CGSize,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) -> CGSize {
            let size = node.layoutSize(fitting: targetSize, pass: pass)
            let ratio = viewModifier.aspectRatio ?? size.width / size.height
            let targetRatio = targetSize.width / targetSize.height
            if targetRatio < ratio {
                return CGSize(
                    width: targetSize.width,
                    height: targetSize.height / ratio
                )
            } else {
                return CGSize(
                    width: targetSize.width * ratio,
                    height: targetSize.height
                )
            }
        }

        func layout(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {
            // TODO: aspectRatio fill/fit
            node.layout(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

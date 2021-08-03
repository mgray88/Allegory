//
// Created by Mike on 8/1/21.
//

import UIKit

/// A scrollable view.
///
/// The scroll view displays its content within the scrollable content region.
/// As the user performs platform-appropriate scroll gestures, the scroll view
/// adjusts what portion of the underlying content is visible. `ScrollView` can
/// scroll horizontally, vertically, or both, but does not provide zooming
/// functionality.
///
/// In the following example, a `ScrollView` allows the user to scroll through a
/// ``VStack`` containing 100 ``Text`` views. You can disable the scroll bar
/// with the `showsIndicators` parameter of the `ScrollView` initializer.
///
/// ```swift
/// var body: some View {
///     ScrollView {
///         VStack(alignment: .leading) {
///             ForEach(0..<100) {
///                 Text("Row \($0)")
///             }
///         }
///     }
/// }
/// ```
public struct ScrollView<Content>: View where Content: View {

    public typealias Body = Swift.Never

    /// The scrollable axes of the scroll view.
    ///
    /// The default value is ``Axis/vertical``.
    public let axes: Axis.Set

    /// A value that indicates whether the scroll view displays the scrollable
    /// component of the content offset, in a way that’s suitable for the
    /// platform.
    ///
    /// The default is `true`.
    public let showsIndicators: Bool

    /// The scroll view's content.
    public let content: Content

    /// Creates a new instance that's scrollable in the direction of the given
    /// axis and can show indicators while scrolling.
    ///
    /// - Parameters:
    ///   - axes: The scroll view’s scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - showsIndicators: A Boolean value that indicates whether the scroll
    ///     view displays the scrollable component of the content offset, in a
    ///     way suitable for the platform. The default value for this parameter
    ///     is `true`.
    ///   - content: The view builder that creates the scrollable view.
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }

}

extension ScrollView: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "ScrollView<\(content.hierarchyIdentifier)>"
        }

        let scrollView = ContainerScrollView()

        var content: SomeUIKitNode!
        var axes: Axis.Set!

        func update(view: ScrollView<Content>, context: Context) {
            self.axes = view.axes
            self.content = view.content.resolve(
                context: context,
                cachedNode: content
            )
            scrollView.showsVerticalScrollIndicator = view.showsIndicators
            scrollView.showsHorizontalScrollIndicator = view.showsIndicators
            scrollView.alwaysBounceVertical = view.axes.contains(.vertical)
            scrollView.alwaysBounceHorizontal = view.axes.contains(.horizontal)
        }

        func layoutSize(fitting targetSize: CGSize, pass: LayoutPass) -> CGSize {
            if axes == [.horizontal, .vertical] {
                return targetSize
            } else if axes == [.vertical] {
                var size = content.layoutSize(
                    fitting: .init(width: targetSize.width, height: 0),
                    pass: pass
                )
                size.height = targetSize.height
                return size
            } else if axes == [.horizontal] {
                var size = content.layoutSize(
                    fitting: .init(width: 0, height: targetSize.height),
                    pass: pass
                )
                size.width = targetSize.width
                return size
            } else {
                fatalError()
            }
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            let contentSize = content.layoutSize(fitting: bounds.size, pass: pass)
            scrollView.frame = bounds.rect
            scrollView.contentSize = contentSize
            container.view.addSubview(scrollView)
            content.layout(
                in: container.replacingView(scrollView),
                bounds: bounds.update(to: .init(origin: .zero, size: contentSize)),
                pass: pass
            )
        }

    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

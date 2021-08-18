//
// Created by Mike on 8/11/21.
//

/// A view that provides programmatic scrolling, by working with a proxy
/// to scroll to known child views.
///
/// The scroll view reader's content view builder receives a ``ScrollViewProxy``
/// instance; you use the proxy's ``ScrollViewProxy/scrollTo(_:anchor:)`` to
/// perform scrolling.
///
/// The following example creates a ``ScrollView`` containing 100 views that
/// together display a color gradient. It also contains two buttons, one each
/// at the top and bottom. The top button tells the ``ScrollViewProxy`` to
/// scroll to the bottom button, and vice versa.
///
///     @Namespace var topID
///     @Namespace var bottomID
///
///     var body: some View {
///         ScrollViewReader { proxy in
///             ScrollView {
///                 Button("Scroll to Bottom") {
///                     withAnimation {
///                         proxy.scrollTo(bottomID)
///                     }
///                 }
///                 .id(topID)
///
///                 VStack(spacing: 0) {
///                     ForEach(0..<100) { i in
///                         color(fraction: Double(i) / 100)
///                             .frame(height: 32)
///                     }
///                 }
///
///                 Button("Top") {
///                     withAnimation {
///                         proxy.scrollTo(topID)
///                     }
///                 }
///                 .id(bottomID)
///             }
///         }
///     }
///
///     func color(fraction: Double) -> Color {
///         Color(red: fraction, green: 1 - fraction, blue: 0.5)
///     }
///
/// > Important: You may not use the ``ScrollViewProxy``
/// during execution of the `content` view builder; doing so results in a
/// runtime error. Instead, only actions created within `content` can call
/// the proxy, such as gesture handlers or a view's `onChange(of:perform:)`
/// method.
public struct ScrollViewReader<Content>: View where Content: View {

    private let proxy = ScrollViewProxy()

    /// The view builder that creates the reader's content.
    public let content: (ScrollViewProxy) -> Content

    /// Creates an instance that can perform programmatic scrolling of its
    /// child scroll views.
    ///
    /// - Parameter content: The reader's content, containing one or more
    /// scroll views. This view builder receives a ``ScrollViewProxy``
    /// instance that you use to perform scrolling.
    @inlinable
    public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
        self.content = content
    }

    public var body: SomeView {
        content(proxy)
    }
}

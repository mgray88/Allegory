//
// Created by Mike on 8/15/21.
//


/// A scene that presents a group of identically structured windows.
///
/// Use a `WindowGroup` as a container for a view hierarchy presented by your
/// app. The hierarchy that you declare as the group's content serves as a
/// template for each window that the app creates from that group:
///
///     @main
///     struct Mail: App {
///         var body: some Scene {
///             WindowGroup {
///                 MailViewer() // Declare a view hierarchy here.
///             }
///         }
///     }
///
/// Allegory takes care of certain platform-specific behaviors. For example,
/// on platforms that support it, like macOS and iPadOS, users can open more
/// than one window from the group simultaneously. In macOS, users
/// can gather open windows together in a tabbed interface. Also in macOS,
/// window groups automatically provide commands for standard window
/// management.
///
/// Every window created from the group maintains independent state. For
/// example, for each new window created from the group the system allocates new
/// storage for any ``State`` or ``StateObject`` variables instantiated by the
/// scene's view hierarchy.
///
/// You typically use a window group for the main interface of an app that isn't
/// document-based. For document-based apps, use a ``DocumentGroup`` instead.
public struct WindowGroup<Content>: Scene, TitledScene where Content: View {
    public let id: String
    public let title: Text?
    public let content: Content

    public init(id: String, @ViewBuilder content: () -> Content) {
        self.id = id
        title = nil
        self.content = content()
    }

    @_disfavoredOverload
    public init(_ title: Text, id: String, @ViewBuilder content: () -> Content) {
        self.id = id
        self.title = title
        self.content = content()
    }

    @_disfavoredOverload
    public init<S>(_ title: S, id: String, @ViewBuilder content: () -> Content)
        where S: StringProtocol {
        self.id = id
        self.title = Text(title)
        self.content = content()
    }

    public init(@ViewBuilder content: () -> Content) {
        id = ""
        title = nil
        self.content = content()
    }

    @_disfavoredOverload
    public init(_ title: Text, @ViewBuilder content: () -> Content) {
        id = ""
        self.title = title
        self.content = content()
    }

    @_disfavoredOverload
    public init<S>(_ title: S, @ViewBuilder content: () -> Content) where S: StringProtocol {
        id = ""
        self.title = Text(title)
        self.content = content()
    }
}

//
// Created by Mike on 8/8/21.
//

/// A type that collects multiple instances of a content type --- like views,
/// scenes, or commands --- into a single unit.
///
/// Use a group to collect multiple views into a single instance, without
/// affecting the layout of those views, like an ``Allegory/HStack``,
/// ``Allegory/VStack``, or ``Allegory/Section`` would. After creating a group,
/// any modifier you apply to the group affects all of that group's members.
/// For example, the following code applies the ``Allegory/Font/headline``
/// font to three views in a group.
///
///     Group {
///         Text("Allegory")
///         Text("Combine")
///         Text("Swift System")
///     }
///     .font(.headline)
///
/// Because you create a group of views with a ``Allegory/ViewBuilder``, you can
/// use the group's initializer to produce different kinds of views from a
/// conditional, and then optionally apply modifiers to them. The following
/// example uses a `Group` to add a navigation bar title,
/// regardless of the type of view the conditional produces:
///
///     Group {
///         if isLoggedIn {
///             WelcomeView()
///         } else {
///             LoginView()
///         }
///     }
///     .navigationBarTitle("Start")
///
/// The modifier applies to all members of the group --- and not to the group
/// itself. For example, if you apply ``View/onAppear(perform:)`` to the above
/// group, it applies to all of the views produced by the `if isLoggedIn`
/// conditional, and it executes every time `isLoggedIn` changes.
///
/// Because a group of views itself is a view, you can compose a group within
/// other view builders, including nesting within other groups. This allows you
/// to add large numbers of views to different view builder containers. The
/// following example uses a `Group` to collect 10 ``Allegory/Text`` instances,
/// meaning that the vertical stack's view builder returns only two views ---
/// the group, plus an additional ``Allegory/Text``:
///
///     var body: some View {
///         VStack {
///             Group {
///                 Text("1")
///                 Text("2")
///                 Text("3")
///                 Text("4")
///                 Text("5")
///                 Text("6")
///                 Text("7")
///                 Text("8")
///                 Text("9")
///                 Text("10")
///             }
///             Text("11")
///         }
///     }
///
/// You can initialize groups with several types other than ``Allegory/View``,
/// such as ``Allegory/Scene`` and ``Allegory/ToolbarContent``. The closure you
/// provide to the group initializer uses the corresponding builder type
/// (``Allegory/SceneBuilder``, ``Allegory/ToolbarContentBuilder``, and so on),
/// and the capabilities of these builders vary between types. For example,
/// you can use groups to return large numbers of scenes or toolbar content
/// instances, but not to return different scenes or toolbar content based
/// on conditionals.
public struct Group<Content> {
    public typealias Body = Never

    @usableFromInline
    internal var content: Content
}

extension Group: View, SomeView where Content: View {
    /// Creates a group of views.
    /// - Parameter content: A ``Allegory/ViewBuilder`` that produces the views
    /// to group.
    @inlinable
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

extension Group: UIKitNodeResolvable where Content: View {
    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        content.resolve(context: context, cachedNode: cachedNode)
    }
}

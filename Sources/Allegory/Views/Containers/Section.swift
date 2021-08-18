//
// Created by Mike on 8/8/21.
//

/// A container view that you can use to add hierarchy to certain collection
/// views.
///
/// > Warning: WIP. Not yet implemented.
///
/// Use `Section` instances in views like ``List``, ``Picker``, and
/// ``Form`` to organize content into separate sections. Each section has
/// custom content that you provide on a per-instance basis. You can also
/// provide headers and footers for each section.
public struct Section<Parent, Content, Footer> {
    internal let header: Parent
    internal let content: Content
    internal let footer: Footer
}

extension Section: View, SomeView where Parent: View, Content: View, Footer: View {
    public typealias Body = Never
}

extension Section where Parent: View, Content: View, Footer: View {

    /// Creates a section with a header, footer, and the provided section
    /// content.
    ///
    /// - Parameters:
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    ///   - footer: A view to use as the section's footer.
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Parent,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
    }
}

extension Section where Parent == EmptyView, Content: View, Footer: View {

    /// Creates a section with a footer and the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    ///   - footer: A view to use as the section's footer.
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.header = EmptyView()
        self.content = content()
        self.footer = footer()
    }
}

extension Section where Parent: View, Content: View, Footer == EmptyView {

    /// Creates a section with a header and the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    ///   - header: A view to use as the section's header.
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Parent
    ) {
        self.header = header()
        self.content = content()
        self.footer = EmptyView()
    }
}

extension Section where Parent == EmptyView, Content: View, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - content: The section's content.
    public init(@ViewBuilder content: () -> Content) {
        self.header = EmptyView()
        self.content = content()
        self.footer = EmptyView()
    }
}

extension Section where Parent == Text, Content: View, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - content: The section's content.
    public init<S>(
        _ title: S,
        @ViewBuilder content: () -> Content
    ) where S: StringProtocol {
        self.header = Text(title)
        self.content = content()
        self.footer = EmptyView()
    }
}

extension Section: UIKitNodeResolvable
    where Parent: View, Content: View, Footer: View {

    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "Section<>"
        }

        func update(view: Section<Parent, Content, Footer>, context: Context) {
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            fatalError("size(fitting:pass:) has not been implemented")
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        }
    }

    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

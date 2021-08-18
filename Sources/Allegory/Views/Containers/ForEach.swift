//
// Created by Mike on 7/31/21.
//

public struct ForEach<Data, ID, Content>
    where Data: RandomAccessCollection, ID: Hashable {

    public let data: Data
    internal let content: (Data.Element) -> Content
    internal let idGenerator: (Data.Element) -> ID
}

extension ForEach: View, SomeView where Content: View {
    public typealias Body = Swift.Never
}

extension ForEach where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - content: The view builder that creates views dynamically.
    public init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.idGenerator = { $0.id }
    }
}

extension ForEach where Content: View {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the provided key path to the underlying data's
    /// identifier.
    ///
    /// It's important that the `id` of a data element doesn't change, unless
    /// SwiftUI considers the data element to have been replaced with a new data
    /// element that has a new identity. If the `id` of a data element changes,
    /// then the content view generated from that data element will lose any
    /// current state and animations.
    ///
    /// - Parameters:
    ///   - data: The data that the ``ForEach`` instance uses to create views
    ///     dynamically.
    ///   - id: The key path to the provided data's identifier.
    ///   - content: The view builder that creates views dynamically.
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.idGenerator = { $0[keyPath: id] }
    }
}

extension ForEach where Content: View {

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - content: The view builder that creates views dynamically.
//    public init<C>(
//        _ data: Binding<C>,
//        @ViewBuilder content: @escaping (Binding<C.Element>) -> Content
//    ) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>,
//        ID == C.Element.ID,
//        C: MutableCollection,
//        C: RandomAccessCollection,
//        C.Element: Identifiable,
//        C.Index: Hashable {
//
//        self.init(data, id: \.id, content: content)
//    }

    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// It's important that the `id` of a data element doesn't change unless you
    /// replace the data element with a new data element that has a new
    /// identity. If the `id` of a data element changes, the content view
    /// generated from that data element loses any current state and animations.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ForEach`` instance uses to
    ///     create views dynamically.
    ///   - content: The view builder that creates views dynamically.
//    public init<C>(
//        _ data: Binding<C>,
//        id: KeyPath<C.Element, ID>,
//        @ViewBuilder content: @escaping (Binding<C.Element>) -> Content
//    ) where Data == LazyMapSequence<C.Indices, (C.Index, ID)>,
//        C: MutableCollection,
//        C: RandomAccessCollection,
//        C.Index: Hashable {
//
//        let elementIDs = data.wrappedValue.indices.lazy.map { index in
//                (index, data.wrappedValue[index][keyPath: id])
//            }
//        self.init(elementIDs, id: \.1) { (index, _) in
//            let elementBinding = Binding {
//                data.wrappedValue[index]
//            } set: {
//                data.wrappedValue[index] = $0
//            }
//            content(elementBinding)
//        }
//    }
}

extension ForEach where Data == Range<Int>, ID == Int, Content: View {
    public init(
        _ data: Range<Int>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.data = data
        self.content = content
        self.idGenerator = { $0 }
    }
}

extension ForEach: TransientContainerView where Content: View {
    var contentViews: [SomeView] {
        data.flatMap { content($0).contentViews }
    }
}

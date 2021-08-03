//
// Created by Mike on 7/31/21.
//

public struct ForEach<Data, ID, Content>: View
    where Data: RandomAccessCollection, ID: Hashable, Content: View {

    public typealias Body = Swift.Never

    internal let data: Data
    internal let content: (Data.Element) -> Content
    internal let idGenerator: (Data.Element) -> ID

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

extension ForEach where ID == Data.Element.ID, Data.Element: Identifiable {
    public init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.content = content
        self.idGenerator = { $0.id }
    }
}

extension ForEach where Data == Range<Int>, ID == Int {
    public init(
        _ data: Range<Int>,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.data = data
        self.content = content
        self.idGenerator = { $0 }
    }
}

extension ForEach: TransientContainerView {
    var contentViews: [SomeView] {
        data.flatMap { content($0).contentViews }
    }
}

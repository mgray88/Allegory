//
// Created by Mike on 8/8/21.
//

/// A type of view that generates views from an underlying collection of data.
public protocol DynamicViewContent: View {

    /// The type of the underlying collection of data.
    associatedtype Data: Collection

    /// The collection of underlying data.
    var data: Self.Data { get }
}

extension ForEach: DynamicViewContent where Content: View {
}

extension ModifiedContent: DynamicViewContent
    where Content: DynamicViewContent, Modifier: ViewModifier {
    public var data: Content.Data {
        content.data
    }
    public typealias Data = Content.Data
}

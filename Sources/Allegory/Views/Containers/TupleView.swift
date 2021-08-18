//
// Created by Mike on 7/31/21.
//

import Foundation

/// A View created from a swift tuple of View values.
public struct TupleView<T>: View {

    public typealias Body = Swift.Never

    public let value: T

    @inlinable
    public init(_ value: T) {
        self.value = value
    }
}

extension TupleView: TransientContainerView {
    var contentViews: [SomeView] {
        Mirror(reflecting: value).children.flatMap { ($0.value as! SomeView).contentViews }
    }
}

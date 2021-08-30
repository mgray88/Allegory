//
// Created by Mike on 8/29/21.
//

public struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    public typealias Index = Base.Index
    public typealias Element = (index: Index, element: Base.Element)
    let base: Base
    public var startIndex: Index { self.base.startIndex }
    public var endIndex: Index { self.base.endIndex }

    public func index(after i: Index) -> Index {
        self.base.index(after: i)
    }

    public func index(before i: Index) -> Index {
        self.base.index(before: i)
    }

    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        self.base.index(i, offsetBy: distance)
    }

    public subscript(position: Index) -> Element {
        (index: position, element: self.base[position])
    }
}

extension RandomAccessCollection {
    public func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}

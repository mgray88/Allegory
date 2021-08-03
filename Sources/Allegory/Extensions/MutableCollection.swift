//
// Created by Mike on 7/31/21.
//

extension MutableCollection {
    @inlinable
    mutating func mutableForEach(_ body: (inout Element) throws -> ()) rethrows {
        for index in indices {
            try body(&self[index])
        }
    }
}

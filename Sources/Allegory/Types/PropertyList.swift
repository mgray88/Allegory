//
// Created by Mike on 8/14/21.
//

@usableFromInline
internal struct PropertyList: CustomStringConvertible {
    @usableFromInline
    internal var elements: PropertyList.Element?

    @inlinable
    internal init() { elements = nil }

    @usableFromInline
    internal var description: String {
        ""
    }
}

extension PropertyList {
    @usableFromInline
    internal class Tracker {
    }
}

extension PropertyList {
    @usableFromInline
    internal class Element: CustomStringConvertible {
        @usableFromInline
        internal var description: String {
            ""
        }

        @usableFromInline
        deinit {}
    }
}

//
// Created by Mike on 8/18/21.
//

@usableFromInline
internal struct AlignmentKey: Hashable, Comparable {
    // TODO: This is bad
//    private let bits: UInt = UInt(UUID().uuidString.hash)

    @usableFromInline
    internal static func < (lhs: AlignmentKey, rhs: AlignmentKey) -> Bool {
        TODO()
    }

    @usableFromInline
    internal static func == (lhs: AlignmentKey, rhs: AlignmentKey) -> Bool {
        TODO()
    }
}

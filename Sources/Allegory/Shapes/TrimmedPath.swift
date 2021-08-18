//
// Created by Mike on 8/17/21.
//

@usableFromInline
internal struct TrimmedPath: Equatable {
    internal let path: Path
    internal let from: CGFloat
    internal let to: CGFloat

    internal init(path: Path, from: CGFloat, to: CGFloat) {
        self.path = path
        self.from = from
        self.to = to
    }

    @usableFromInline
    static func ==(lhs: TrimmedPath, rhs: TrimmedPath) -> Bool {
        lhs.path == rhs.path && lhs.from == rhs.from && lhs.to == rhs.to
    }
}

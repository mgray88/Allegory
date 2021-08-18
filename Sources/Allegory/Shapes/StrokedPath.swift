//
// Created by Mike on 8/17/21.
//

@usableFromInline
internal struct StrokedPath: Equatable {
    internal let path: Path
    internal let style: StrokeStyle

    internal init(path: Path, style: StrokeStyle) {
        self.path = path
        self.style = style
    }

    @usableFromInline
    static func ==(lhs: StrokedPath, rhs: StrokedPath) -> Bool {
        lhs.path == rhs.path && lhs.style == rhs.style
    }
}

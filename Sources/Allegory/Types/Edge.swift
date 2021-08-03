//
// Created by Mike on 7/29/21.
//

public enum Edge: Int8, CaseIterable, Hashable {

    case top
    case leading
    case bottom
    case trailing

    public struct Set: OptionSet {

        public typealias Element = Edge.Set

        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let top = Edge.Set(.top)
        public static let leading = Edge.Set(.leading)
        public static let bottom = Edge.Set(.bottom)
        public static let trailing = Edge.Set(.trailing)
        public static let all: Edge.Set = [.top, .leading, .bottom, .trailing]
        public static let horizontal: Edge.Set = [.leading, .trailing]
        public static let vertical: Edge.Set = [.top, .bottom]

        public init(_ e: Edge) {
            self.init(rawValue: 1 << e.rawValue)
        }
    }
}

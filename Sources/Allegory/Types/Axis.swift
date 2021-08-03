//
// Created by Mike on 8/1/21.
//

public enum Axis: Int8, CaseIterable {
    case vertical
    case horizontal

    public struct Set: OptionSet {
        public let rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }

        public static let horizontal: Axis.Set = .init(rawValue: 1 << 0)
        public static let vertical: Axis.Set = .init(rawValue: 1 << 1)
    }

}

extension Axis {

    @inlinable
    public var flipped: Axis {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        }
    }
}

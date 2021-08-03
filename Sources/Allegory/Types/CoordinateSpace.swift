//
// Created by Mike on 7/31/21.
//

public enum CoordinateSpace {
    case global
    case local

    /// > Warning: Not implemented
    case named(AnyHashable)
}

extension CoordinateSpace {
    @inlinable
    public var isGlobal: Bool {
        switch self {
        case .global:
            return true
        default:
            return false
        }
    }

    @inlinable
    public var isLocal: Bool {
        switch self {
        case .local:
            return true
        default:
            return false
        }
    }
}

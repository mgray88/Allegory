//
// Created by Mike on 7/27/21.
//

extension Double {
    var cgFloat: CGFloat {
        CGFloat(self)
    }
}

extension Optional where Wrapped == Double {
    @usableFromInline
    var cgFloat: CGFloat? {
        switch self {
        case .none: return nil
        case let .some(value):
            return CGFloat(value)
        }
    }
}

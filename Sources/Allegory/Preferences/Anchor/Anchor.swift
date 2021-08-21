//
// Created by Mike on 8/19/21.
//

public struct Anchor<Value> {
    fileprivate let box: AnchorValueBoxBase<Value>
    public struct Source {
        private var box: AnchorBoxBase<Value>
    }
}

extension Anchor: Equatable where Value: Equatable {
    public static func == (lhs: Anchor<Value>, rhs: Anchor<Value>) -> Bool {
        TODO()
    }
}
extension Anchor: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        TODO()
    }
}

extension Anchor.Source {
    public init<T>(_ array: [Anchor<T>.Source]) where Value == [T] {
        TODO()
    }
}

extension Anchor.Source {
    public init<T>(_ anchor: Anchor<T>.Source?) where Value == T? {
        TODO()
    }
}

extension Anchor.Source where Value == CGRect {
    public static func rect(_ r: CGRect) -> Anchor<Value>.Source {
        TODO()
    }

    public static var bounds: Anchor<CGRect>.Source {
        get {
            TODO()
        }
    }
}

extension Anchor.Source where Value == CGPoint {
    public static func point(_ p: CGPoint) -> Anchor<Value>.Source {
        TODO()
    }

    public static func unitPoint(_ p: UnitPoint) -> Anchor<Value>.Source {
        TODO()
    }

    public static var topLeading: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var top: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var topTrailing: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var leading: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var center: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var trailing: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var bottomLeading: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var bottom: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }

    public static var bottomTrailing: Anchor<CGPoint>.Source {
        get {
            TODO()
        }
    }
}

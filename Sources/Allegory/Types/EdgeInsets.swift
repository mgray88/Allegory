//
// Created by Mike on 6/15/21.
//

public struct EdgeInsets: Hashable {
    public var top: Double
    public var left: Double
    public var bottom: Double
    public var right: Double

    public var leading: Double {
        get { left }
        set { left = newValue }
    }

    public var trailing: Double {
        get { right }
        set { right = newValue }
    }

    @inlinable
    public init() {
        self.init(top: 0, left: 0, bottom: 0, right: 0)
    }

    @inlinable
    public init(_ value: Double) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    @inlinable
    public init(top: Double, left: Double, bottom: Double, right: Double) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }

    @inlinable
    public init(top: Double, leading: Double, bottom: Double, trailing: Double) {
        self.top = top
        self.left = leading
        self.bottom = bottom
        self.right = trailing
    }

    @inlinable
    public static var zero: EdgeInsets {
        .init()
    }
}

extension EdgeInsets {
    public static func uniform(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: value, left: value, bottom: value, right: value)
    }

    public static func top(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }

    public static func left(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }

    public static func leading(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: 0)
    }

    public static func bottom(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }

    public static func right(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }

    public static func trailing(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: value)
    }

    public static func horizontal(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }

    public static func vertical(_ value: Double) -> EdgeInsets {
        EdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }
}

public func + (lhs: EdgeInsets, rhs: EdgeInsets) -> EdgeInsets {
    .init(
        top: lhs.top + rhs.top,
        left: lhs.left + rhs.left,
        bottom: lhs.bottom + rhs.bottom,
        right: lhs.right + rhs.right
    )
}

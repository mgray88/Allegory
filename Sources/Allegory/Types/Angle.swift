//
// Created by Mike on 8/14/21.
//

public struct Angle: AdditiveArithmetic {
    public var radians: Double
    public var degrees: Double {
        get { radians * (180.0 / .pi) }
        set { radians = newValue * (.pi / 180.0) }
    }

    public init() {
        self.init(radians: 0.0)
    }

    public init(radians: Double) {
        self.radians = radians
    }

    public init(degrees: Double) {
        self.init(radians: degrees * (.pi / 180.0))
    }

    public static func radians(_ radians: Double) -> Angle {
        Angle(radians: radians)
    }

    public static func degrees(_ degrees: Double) -> Angle {
        Angle(degrees: degrees)
    }

    public static let zero: Angle = .radians(0)

    public static func + (lhs: Self, rhs: Self) -> Self {
        .radians(lhs.radians + rhs.radians)
    }

    public static func += (lhs: inout Self, rhs: Self) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs + rhs
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        .radians(lhs.radians - rhs.radians)
    }

    public static func -= (lhs: inout Self, rhs: Self) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs - rhs
    }
}

extension Angle: Hashable, Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.radians < rhs.radians
    }
}

extension Angle: Animatable, _VectorMath {
    public var animatableData: Double {
        get { radians }
        set { radians = newValue }
    }
}

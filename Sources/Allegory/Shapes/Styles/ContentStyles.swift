//
// Created by Mike on 8/14/21.
//

/// A shape style that maps to one of the numbered content styles.
public struct HierarchicalShapeStyle: ShapeStyle {
    @usableFromInline
    internal var id: UInt32

    @inlinable
    internal init(id: UInt32) {
        self.id = id
    }

    public static let primary: HierarchicalShapeStyle = .init(id: 0)
    public static let secondary: HierarchicalShapeStyle = .init(id: 1)
    public static let tertiary: HierarchicalShapeStyle = .init(id: 2)
    public static let quaternary: HierarchicalShapeStyle = .init(id: 3)

    public func _apply(to shape: inout _ShapeStyle_Shape) {
        TODO()
    }
}

extension ShapeStyle where Self == HierarchicalShapeStyle {

    /// A shape style that maps to the first level of the current
    /// content style.
    public static var primary: HierarchicalShapeStyle {
        get { .primary }
    }

    /// A shape style that maps to the second level of the current
    /// content style.
    public static var secondary: HierarchicalShapeStyle {
        get { .secondary }
    }

    /// A shape style that maps to the third level of the current
    /// content style.
    public static var tertiary: HierarchicalShapeStyle {
        get { .tertiary }
    }

    /// A shape style that maps to the fourth level of the current
    /// content style.
    public static var quaternary: HierarchicalShapeStyle {
        get { .quaternary }
    }
}

//public struct PrimaryContentStyle {
//    @inlinable
//    public init() {}
//}
//
//extension PrimaryContentStyle: ShapeStyle {
//    public func _apply(to shape: inout _ShapeStyle_Shape) {
//        if !shape.inRecursiveStyle,
//           let foregroundStyle = shape.environment._foregroundStyle
//        {
//            if foregroundStyle.styles.primary is Self {
//                shape.inRecursiveStyle = true
//            }
//            foregroundStyle.styles.primary._apply(to: &shape)
//        } else {
//            shape.result = .color(shape.environment.foregroundColor ?? .primary)
//        }
//    }
//
//    public static func _apply(to shape: inout _ShapeStyle_ShapeType) {}
//}
//
//@frozen public struct SecondaryContentStyle {
//    @inlinable
//    public init() {}
//}
//
//extension SecondaryContentStyle: ShapeStyle {
//    public func _apply(to shape: inout _ShapeStyle_Shape) {
//        if !shape.inRecursiveStyle,
//           let foregroundStyle = shape.environment._foregroundStyle
//        {
//            if foregroundStyle.styles.secondary is Self {
//                shape.inRecursiveStyle = true
//            }
//            foregroundStyle.styles.secondary._apply(to: &shape)
//        } else {
//            shape.result = .color((shape.environment.foregroundColor ?? .primary).opacity(0.5))
//        }
//    }
//
//    public static func _apply(to shape: inout _ShapeStyle_ShapeType) {}
//}
//
//@frozen public struct TertiaryContentStyle {
//    @inlinable
//    public init() {}
//}
//
//extension TertiaryContentStyle: ShapeStyle {
//    public func _apply(to shape: inout _ShapeStyle_Shape) {
//        if !shape.inRecursiveStyle,
//           let foregroundStyle = shape.environment._foregroundStyle
//        {
//            if foregroundStyle.styles.tertiary is Self {
//                shape.inRecursiveStyle = true
//            }
//            foregroundStyle.styles.tertiary._apply(to: &shape)
//        } else {
//            shape.result = .color((shape.environment.foregroundColor ?? .primary).opacity(0.3))
//        }
//    }
//
//    public static func _apply(to shape: inout _ShapeStyle_ShapeType) {}
//}
//
//@frozen public struct QuaternaryContentStyle {
//    @inlinable
//    public init() {}
//}
//
//extension QuaternaryContentStyle: ShapeStyle {
//    public func _apply(to shape: inout _ShapeStyle_Shape) {
//        if !shape.inRecursiveStyle,
//           let foregroundStyle = shape.environment._foregroundStyle
//        {
//            if foregroundStyle.styles.tertiary is Self {
//                shape.inRecursiveStyle = true
//            }
//            foregroundStyle.styles.tertiary._apply(to: &shape)
//        } else {
//            shape.result = .color((shape.environment.foregroundColor ?? .primary).opacity(0.2))
//        }
//    }
//
//    public static func _apply(to shape: inout _ShapeStyle_ShapeType) {}
//}

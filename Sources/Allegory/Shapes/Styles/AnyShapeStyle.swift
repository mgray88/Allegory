//
// Created by Mike on 7/31/21.
//

/// A type-erased ``ShapeStyle`` value.
public struct AnyShapeStyle: ShapeStyle {

    @usableFromInline
    internal struct Storage: Equatable {
        internal let box: AnyShapeStyleBox

        @usableFromInline
        internal static func == (lhs: Storage, rhs: Storage) -> Bool {
            lhs.box === rhs.box
        }
    }

    internal let storage: Storage

    /// Create an instance from `style`.
    public init<S>(_ style: S) where S: ShapeStyle {
        storage = .init(box: .init(shapeStyle: style))
    }

    public func _apply(to shape: inout _ShapeStyle_Shape) {
        storage.box.shapeStyle._apply(to: &shape)
    }
}

internal class AnyShapeStyleBox {
    internal let shapeStyle: ShapeStyle

    internal init(shapeStyle: ShapeStyle) {
        self.shapeStyle = shapeStyle
    }
}

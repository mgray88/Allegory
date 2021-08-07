//
// Created by Mike on 7/31/21.
//

/// A type-erased ``ShapeStyle`` value.
public struct AnyShapeStyle: ShapeStyle {

    private let style: ShapeStyle

    /// Create an instance from `style`.
    public init<S>(_ style: S) where S: ShapeStyle {
        self.style = style
    }

    public func `in`(_ rect: CGRect) -> SomeShapeStyle {
        style.in(rect)
    }
}

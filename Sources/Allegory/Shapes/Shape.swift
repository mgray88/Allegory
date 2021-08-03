//
// Created by Mike on 7/27/21.
//

/// A 2D shape that you can use when drawing a view.
///
/// Shapes without an explicit fill or stroke get a default fill based on the
/// foreground color.
///
/// You can define shapes in relation to an implicit frame of reference, such as
/// the natural size of the view that contains it. Alternatively, you can define
/// shapes in terms of absolute coordinates.
public protocol Shape: View, SomeShape {
    /// Trims this shape by a fractional amount based on its representation as a
    /// path.
    ///
    /// - Parameters:
    ///   - startFraction: The fraction of the way through drawing this shape
    ///     where drawing starts.
    ///   - endFraction: The fraction of the way through drawing this shape
    ///     where drawing ends.
    /// - Returns: A shape built by capturing a portion of this shape’s path.
    //func trim(from startFraction: CGFloat, to endFraction: CGFloat) -> SomeShape
}

extension Shape {
    public static var role: ShapeRole {
        .fill
    }
}

extension Shape {
    public static var typeIdentifier: String {
        String(reflecting: self)
    }

    public var body: _ShapeView<Self, ForegroundStyle> {
        _ShapeView(shape: self, style: ForegroundStyle())
    }
}

public enum ShapeRole {
    case fill
    case stroke
}

extension Shape where Body == Never {
    public var body: Never {
        fatalError()
    }
}

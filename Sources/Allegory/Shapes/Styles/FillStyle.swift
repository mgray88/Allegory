//
// Created by Mike on 7/31/21.
//

/// A style for rasterizing vector shapes.
///
/// > Warning: Use of this struct is currently a no-op.
public struct FillStyle: Equatable {

    /// A Boolean value that indicates whether to use the even-odd rule when
    /// rendering a shape.
    ///
    /// When `isOEFilled` is `false`, the style uses the non-zero winding number
    /// rule.
    public var isEOFilled: Bool

    /// A Boolean value that indicates whether to apply antialiasing the edges
    /// of a shape.
    public var isAntialiased: Bool

    /// Creates a new fill style with the specified settings.
    ///
    /// - Parameters:
    ///   - eoFill: A Boolean value that indicates whether to use the even-od
    ///     rule for rendering a shape. Pass `false` to use the non-zero winding
    ///     number rule instead.
    ///   - antialiased: A Boolean value that indicates whether to use
    ///     antialiasing when rendering the edges of a shape.
    public init(eoFill: Bool = false, antialiased: Bool = true) {
        self.isEOFilled = eoFill
        self.isAntialiased = antialiased
    }
}

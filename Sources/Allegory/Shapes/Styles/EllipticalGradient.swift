//
// Created by Mike on 8/21/21.
//

/// A radial gradient that draws an ellipse.
///
/// The gradient maps its coordinate space to the unit space square
/// in which its center and radii are defined, then stretches that
/// square to fill its bounding rect, possibly also stretching the
/// circular gradient to have elliptical contours.
///
/// For example, an elliptical gradient centered on the view, filling
/// its bounds:
///
///     EllipticalGradient(gradient: .init(colors: [.red, .yellow]))
///
/// When using an elliptical gradient as a shape style, you can also use
/// ``ShapeStyle/ellipticalGradient(_:center:startRadiusFraction:endRadiusFraction:)``.
public struct EllipticalGradient : ShapeStyle, View {
    internal var gradient: Gradient
    internal var center: UnitPoint
    internal var startRadiusFraction: CGFloat
    internal var endRadiusFraction: CGFloat

    /// Creates an elliptical gradient.
    ///
    /// For example, an elliptical gradient centered on the top-leading
    /// corner of the view:
    ///
    ///     EllipticalGradient(
    ///         gradient: .init(colors: [.blue, .green]),
    ///         center: .topLeading,
    ///         startRadiusFraction: 0,
    ///         endRadiusFraction: 1)
    ///
    /// - Parameters:
    ///  - gradient: The colors and their parametric locations.
    ///  - center: The center of the circle, in [0, 1] coordinates.
    ///  - startRadiusFraction: The start radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    ///  - endRadiusFraction: The end radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    public init(
        gradient: Gradient,
        center: UnitPoint = .center,
        startRadiusFraction: CGFloat = 0,
        endRadiusFraction: CGFloat = 0.5
    ) {
        self.gradient = gradient
        self.center = center
        self.startRadiusFraction = startRadiusFraction
        self.endRadiusFraction = endRadiusFraction
    }

    /// Creates an elliptical gradient from a collection of colors.
    ///
    /// For example, an elliptical gradient centered on the top-leading
    /// corner of the view:
    ///
    ///     EllipticalGradient(
    ///         colors: [.blue, .green],
    ///         center: .topLeading,
    ///         startRadiusFraction: 0,
    ///         endRadiusFraction: 1)
    ///
    /// - Parameters:
    ///  - colors: The colors, evenly distributed throughout the gradient.
    ///  - center: The center of the circle, in [0, 1] coordinates.
    ///  - startRadiusFraction: The start radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    ///  - endRadiusFraction: The end radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    public init(
        colors: [Color],
        center: UnitPoint = .center,
        startRadiusFraction: CGFloat = 0,
        endRadiusFraction: CGFloat = 0.5
    ) {
        self.init(
            gradient: Gradient(colors: colors),
            center: center,
            startRadiusFraction: startRadiusFraction,
            endRadiusFraction: endRadiusFraction
        )
    }

    /// Creates an elliptical gradient from a collection of color stops.
    ///
    /// For example, an elliptical gradient centered on the top-leading
    /// corner of the view, with some extra green area:
    ///
    ///     EllipticalGradient(
    ///         stops: [
    ///             .init(color: .blue, location: 0.0),
    ///             .init(color: .green, location: 0.9),
    ///             .init(color: .green, location: 1.0),
    ///         ],
    ///         center: .topLeading,
    ///         startRadiusFraction: 0,
    ///         endRadiusFraction: 1)
    ///
    /// - Parameters:
    ///  - stops: The colors and their parametric locations.
    ///  - center: The center of the circle, in [0, 1] coordinates.
    ///  - startRadiusFraction: The start radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    ///  - endRadiusFraction: The end radius value, as a fraction
    ///    between zero and one. Zero maps to the center point, one
    ///    maps to the diameter of the unit circle.
    public init(
        stops: [Gradient.Stop],
        center: UnitPoint = .center,
        startRadiusFraction: CGFloat = 0,
        endRadiusFraction: CGFloat = 0.5
    ) {
        self.init(
            gradient: Gradient(stops: stops),
            center: center,
            startRadiusFraction: startRadiusFraction,
            endRadiusFraction: endRadiusFraction
        )
    }

    public typealias Body = _ShapeView<Rectangle, EllipticalGradient>
}

extension ShapeStyle where Self == EllipticalGradient {

    /// A radial gradient that draws an ellipse.
    ///
    /// The gradient maps its coordinate space to the unit space square
    /// in which its center and radii are defined, then stretches that
    /// square to fill its bounding rect, possibly also stretching the
    /// circular gradient to have elliptical contours.
    ///
    /// For example, an elliptical gradient used as a background:
    ///
    ///     let gradient = Gradient(colors: [.red, .yellow])
    ///
    ///     ContentView()
    ///         .background(.ellipticalGradient(gradient))
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func ellipticalGradient(
        _ gradient: Gradient,
        center: UnitPoint = .center,
        startRadiusFraction: CGFloat = 0,
        endRadiusFraction: CGFloat = 0.5
    ) -> EllipticalGradient {
        .init(
            gradient: gradient,
            center: center,
            startRadiusFraction: startRadiusFraction,
            endRadiusFraction: endRadiusFraction
        )
    }

    /// A radial gradient that draws an ellipse defined by a collection of
    /// colors.
    ///
    /// The gradient maps its coordinate space to the unit space square
    /// in which its center and radii are defined, then stretches that
    /// square to fill its bounding rect, possibly also stretching the
    /// circular gradient to have elliptical contours.
    ///
    /// For example, an elliptical gradient used as a background:
    ///
    ///     .background(.elliptical(colors: [.red, .yellow]))
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func ellipticalGradient(
        colors: [Color],
        center: UnitPoint = .center,
        startRadiusFraction: CGFloat = 0,
        endRadiusFraction: CGFloat = 0.5
    ) -> EllipticalGradient {
        .init(
            colors: colors,
            center: center,
            startRadiusFraction: startRadiusFraction,
            endRadiusFraction: endRadiusFraction
        )
    }

    /// A radial gradient that draws an ellipse defined by a collection of
    /// color stops.
    ///
    /// The gradient maps its coordinate space to the unit space square
    /// in which its center and radii are defined, then stretches that
    /// square to fill its bounding rect, possibly also stretching the
    /// circular gradient to have elliptical contours.
    ///
    /// For example, an elliptical gradient used as a background:
    ///
    ///     .background(.ellipticalGradient(stops: [
    ///         .init(color: .red, location: 0.0),
    ///         .init(color: .yellow, location: 0.9),
    ///         .init(color: .yellow, location: 1.0),
    ///     ]))
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func ellipticalGradient(
        stops: [Gradient.Stop],
        center: UnitPoint = .center,
        startRadiusFraction: CGFloat = 0,
        endRadiusFraction: CGFloat = 0.5
    ) -> EllipticalGradient {
        .init(
            stops: stops,
            center: center,
            startRadiusFraction: startRadiusFraction,
            endRadiusFraction: endRadiusFraction
        )
    }
}

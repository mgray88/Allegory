//
// Created by Mike on 8/21/21.
//
/// A radial gradient.
///
/// The gradient applies the color function as the distance from a center
/// point, scaled to fit within the defined start and end radii. The
/// gradient maps the unit space center point into the bounding rectangle of
/// each shape filled with the gradient.
///
/// When using a radial gradient as a shape style, you can also use
/// ``ShapeStyle/radialGradient(_:center:startRadius:endRadius:)``.
public struct RadialGradient: ShapeStyle, View {
    internal var gradient: Gradient
    internal var center: UnitPoint
    internal var startRadius: CGFloat
    internal var endRadius: CGFloat

    /// Creates a radial gradient from a base gradient.
    public init(
        gradient: Gradient,
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) {
        self.gradient = gradient
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    /// Creates a radial gradient from a collection of colors.
    public init(
        colors: [Color],
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) {
        self.init(
            gradient: Gradient(colors: colors),
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }

    /// Creates a radial gradient from a collection of color stops.
    public init(
        stops: [Gradient.Stop],
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) {
        self.init(
            gradient: Gradient(stops: stops),
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }

    public typealias Body = _ShapeView<Rectangle, RadialGradient>
}

extension ShapeStyle where Self == RadialGradient {

    /// A radial gradient.
    ///
    /// The gradient applies the color function as the distance from a center
    /// point, scaled to fit within the defined start and end radii. The
    /// gradient maps the unit space center point into the bounding rectangle of
    /// each shape filled with the gradient.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func radialGradient(
        _ gradient: Gradient,
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) -> RadialGradient {
        .init(
            gradient: gradient,
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }

    /// A radial gradient defined by a collection of colors.
    ///
    /// The gradient applies the color function as the distance from a center
    /// point, scaled to fit within the defined start and end radii. The
    /// gradient maps the unit space center point into the bounding rectangle of
    /// each shape filled with the gradient.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func radialGradient(
        colors: [Color],
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) -> RadialGradient {
        .init(
            colors: colors,
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }

    /// A radial gradient defined by a collection of color stops.
    ///
    /// The gradient applies the color function as the distance from a center
    /// point, scaled to fit within the defined start and end radii. The
    /// gradient maps the unit space center point into the bounding rectangle of
    /// each shape filled with the gradient.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func radialGradient(
        stops: [Gradient.Stop],
        center: UnitPoint,
        startRadius: CGFloat,
        endRadius: CGFloat
    ) -> RadialGradient {
        .init(
            stops: stops,
            center: center,
            startRadius: startRadius,
            endRadius: endRadius
        )
    }
}

extension RadialGradient: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.type = .axial
        gradiantLayer.colors = gradient.stops.map { $0.color.cgColor as Any }
        gradiantLayer.startPoint = center.cgPoint
//        gradiantLayer.endPoint = endPoint.cgPoint
        gradiantLayer.locations = gradient.stops.map {
            NSNumber(value: Float($0.location))
        }
        layer.addSublayer(gradiantLayer)
    }
}

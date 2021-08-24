//
// Created by Mike on 8/21/21.
//

/// A linear gradient.
///
/// The gradient applies the color function along an axis, as defined by its
/// start and end points. The gradient maps the unit space points into the
/// bounding rectangle of each shape filled with the gradient.
///
/// When using a linear gradient as a shape style, you can also use
/// ``ShapeStyle/linearGradient(_:startPoint:endPoint:)``.
public struct LinearGradient: ShapeStyle, View {
    internal var gradient: Gradient
    internal var startPoint: UnitPoint
    internal var endPoint: UnitPoint

    /// Creates a linear gradient from a base gradient.
    public init(gradient: Gradient, startPoint: UnitPoint, endPoint: UnitPoint) {
        self.gradient = gradient
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    /// Creates a linear gradient from a collection of colors.
    public init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(
            gradient: Gradient(colors: colors),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    /// Creates a linear gradient from a collection of color stops.
    public init(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.init(
            gradient: Gradient(stops: stops),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    public typealias Body = _ShapeView<Rectangle, LinearGradient>
}

extension ShapeStyle where Self == LinearGradient {

    /// A linear gradient.
    ///
    /// The gradient applies the color function along an axis, as defined by its
    /// start and end points. The gradient maps the unit space points into the
    /// bounding rectangle of each shape filled with the gradient.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func linearGradient(
        _ gradient: Gradient,
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> LinearGradient {
        .init(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }

    /// A linear gradient defined by a collection of colors.
    ///
    /// The gradient applies the color function along an axis, as defined by its
    /// start and end points. The gradient maps the unit space points into the
    /// bounding rectangle of each shape filled with the gradient.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func linearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> LinearGradient {
        .init(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }

    /// A linear gradient defined by a collection of color stops.
    ///
    /// The gradient applies the color function along an axis, as defined by its
    /// start and end points. The gradient maps the unit space points into the
    /// bounding rectangle of each shape filled with the gradient.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    @inlinable
    public static func linearGradient(
        stops: [Gradient.Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> LinearGradient {
        .init(stops: stops, startPoint: startPoint, endPoint: endPoint)
    }
}

extension LinearGradient: ShapeStyleRenderable {
    func render(
        to layer: CAShapeLayer,
        context: Context
    ) {
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.type = .axial
        gradiantLayer.colors = gradient.stops.map { $0.color.cgColor as Any }
        gradiantLayer.startPoint = startPoint.cgPoint
        gradiantLayer.endPoint = endPoint.cgPoint
        gradiantLayer.locations = gradient.stops.map {
            NSNumber(value: Float($0.location))
        }
        layer.addSublayer(gradiantLayer)
    }
}

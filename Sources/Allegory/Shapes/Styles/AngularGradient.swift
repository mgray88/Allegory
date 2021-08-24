//
// Created by Mike on 8/21/21.
//

import QuartzCore

/// An angular gradient.
///
/// An angular gradient is also known as a "conic" gradient. This gradient
/// applies the color function as the angle changes, relative to a center
/// point and defined start and end angles. If `endAngle - startAngle > 2π`,
/// the gradient only draws the last complete turn. If
/// `endAngle - startAngle < 2π`, the gradient fills the missing area with
/// the colors defined by gradient locations one and zero, transitioning
/// between the two halfway across the missing area. The gradient maps the
/// unit space center point into the bounding rectangle of each shape filled
/// with the gradient.
///
/// When using an angular gradient as a shape style, you can also use
/// ``ShapeStyle/angularGradient(_:center:startAngle:endAngle:)``,
/// ``ShapeStyle/conicGradient(_:center:angle:)``, or similar methods.
public struct AngularGradient : ShapeStyle, View {
    internal var gradient: Gradient
    internal var center: UnitPoint
    internal var startAngle: Angle
    internal var endAngle: Angle

    /// Creates an angular gradient.
    public init(
        gradient: Gradient,
        center: UnitPoint,
        startAngle: Angle = .zero,
        endAngle: Angle = .zero
    ) {
        self.gradient = gradient
        self.center = center
        self.startAngle = startAngle
        self.endAngle = endAngle
    }

    /// Creates an angular gradient from a collection of colors.
    public init(
        colors: [Color],
        center: UnitPoint,
        startAngle: Angle,
        endAngle: Angle
    ) {
        self.init(
            gradient: Gradient(colors: colors),
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// Creates an angular gradient from a collection of color stops.
    public init(
        stops: [Gradient.Stop],
        center: UnitPoint,
        startAngle: Angle,
        endAngle: Angle
    ) {
        self.init(
            gradient: Gradient(stops: stops),
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// Creates a conic gradient that completes a full turn.
    public init(
        gradient: Gradient,
        center: UnitPoint,
        angle: Angle = .zero
    ) {
        self.init(
            gradient: gradient,
            center: center,
            startAngle: .zero,
            endAngle: angle
        )
    }

    /// Creates a conic gradient from a collection of colors that completes
    /// a full turn.
    public init(
        colors: [Color],
        center: UnitPoint,
        angle: Angle = .zero
    ) {
        self.init(
            gradient: Gradient(colors: colors),
            center: center,
            angle: angle
        )
    }

    /// Creates a conic gradient from a collection of color stops that
    /// completes a full turn.
    public init(
        stops: [Gradient.Stop],
        center: UnitPoint,
        angle: Angle = .zero
    ) {
        self.init(
            gradient: Gradient(stops: stops),
            center: center,
            angle: angle
        )
    }

    public typealias Body = _ShapeView<Rectangle, AngularGradient>
}

extension ShapeStyle where Self == AngularGradient {

    /// An angular gradient, which applies the color function as the angle
    /// changes between the start and end angles, and anchored to a relative
    /// center point within the filled shape.
    ///
    /// An angular gradient is also known as a "conic" gradient. If
    /// `endAngle - startAngle > 2π`, the gradient only draws the last complete
    /// turn. If `endAngle - startAngle < 2π`, the gradient fills the missing
    /// area with the colors defined by gradient stop locations at `0` and `1`,
    /// transitioning between the two halfway across the missing area.
    ///
    /// For example, an angular gradient used as a background:
    ///
    ///     let gradient = Gradient(colors: [.red, .yellow])
    ///
    ///     ContentView()
    ///         .background(.angularGradient(gradient))
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    ///
    /// - Parameters:
    ///   - gradient: The gradient to use for filling the shape, providing the
    ///     colors and their relative stop locations.
    ///   - center: The relative center of the gradient, mapped from the unit
    ///     space into the bounding rectangle of the filled shape.
    ///   - startAngle: The angle that marks the beginning of the gradient.
    ///   - endAngle: The angle that marks the end of the gradient.
    @inlinable
    public static func angularGradient(
        _ gradient: Gradient,
        center: UnitPoint,
        startAngle: Angle,
        endAngle: Angle
    ) -> AngularGradient {
        .init(
            gradient: gradient,
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// An angular gradient defined by a collection of colors.
    ///
    /// For more information on how to use angular gradients, see
    /// ``ShapeStyle/angularGradient(_:center:startAngle:endAngle:)``.
    ///
    /// - Parameters:
    ///   - colors: The colors of the gradient, evenly spaced along its full
    ///     length.
    ///   - center: The relative center of the gradient, mapped from the unit
    ///     space into the bounding rectangle of the filled shape.
    ///   - startAngle: The angle that marks the beginning of the gradient.
    ///   - endAngle: The angle that marks the end of the gradient.
    @inlinable
    public static func angularGradient(
        colors: [Color],
        center: UnitPoint,
        startAngle: Angle,
        endAngle: Angle
    ) -> AngularGradient {
        .init(
            colors: colors,
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }

    /// An angular gradient defined by a collection of color stops.
    ///
    /// For more information on how to use angular gradients, see
    /// ``ShapeStyle/angularGradient(_:center:startAngle:endAngle:)``.
    ///
    /// - Parameters:
    ///   - stops: The color stops of the gradient, defining each component
    ///     color and their relative location along the gradient's full length.
    ///   - center: The relative center of the gradient, mapped from the unit
    ///     space into the bounding rectangle of the filled shape.
    ///   - startAngle: The angle that marks the beginning of the gradient.
    ///   - endAngle: The angle that marks the end of the gradient.
    @inlinable
    public static func angularGradient(
        stops: [Gradient.Stop],
        center: UnitPoint,
        startAngle: Angle,
        endAngle: Angle
    ) -> AngularGradient {
        .init(
            stops: stops,
            center: center,
            startAngle: startAngle,
            endAngle: endAngle
        )
    }
}

extension ShapeStyle where Self == AngularGradient {

    /// A conic gradient that completes a full turn, optionally starting from
    /// a given angle and anchored to a relative center point within the filled
    /// shape.
    ///
    /// For example, a conic gradient used as a background:
    ///
    ///     let gradient = Gradient(colors: [.red, .yellow])
    ///
    ///     ContentView()
    ///         .background(.conicGradient(gradient))
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    ///
    /// - Parameters:
    ///   - gradient: The gradient to use for filling the shape, providing the
    ///     colors and their relative stop locations.
    ///   - center: The relative center of the gradient, mapped from the unit
    ///     space into the bounding rectangle of the filled shape.
    ///   - angle: The angle to offset the beginning of the gradient's full
    ///     turn.
    @inlinable
    public static func conicGradient(
        _ gradient: Gradient,
        center: UnitPoint,
        angle: Angle = .zero
    ) -> AngularGradient {
        .init(gradient: gradient, center: center, angle: angle)
    }

    /// A conic gradient defined by a collection of colors that completes a full
    /// turn.
    ///
    /// For more information on how to use angular gradients, see
    /// ``ShapeStyle/conicGradient(_:center:angle:)``.
    ///
    /// - Parameters:
    ///   - colors: The colors of the gradient, evenly spaced along its full
    ///     length.
    ///   - center: The relative center of the gradient, mapped from the unit
    ///     space into the bounding rectangle of the filled shape.
    ///   - angle: The angle to offset the beginning of the gradient's full
    ///     turn.
    @inlinable
    public static func conicGradient(
        colors: [Color],
        center: UnitPoint,
        angle: Angle = .zero
    ) -> AngularGradient {
        .init(colors: colors, center: center, angle: angle)
    }

    /// A conic gradient defined by a collection of color stops that completes a
    /// full turn.
    ///
    /// For more information on how to use angular gradients, see
    /// ``ShapeStyle/conicGradient(_:center:angle:)``.
    ///
    /// - Parameters:
    ///   - stops: The color stops of the gradient, defining each component
    ///     color and their relative location along the gradient's full length.
    ///   - center: The relative center of the gradient, mapped from the unit
    ///     space into the bounding rectangle of the filled shape.
    ///   - angle: The angle to offset the beginning of the gradient's full
    ///     turn.
    @inlinable
    public static func conicGradient(
        stops: [Gradient.Stop],
        center: UnitPoint,
        angle: Angle = .zero
    ) -> AngularGradient {
        .init(stops: stops, center: center, angle: angle)
    }
}

extension AngularGradient: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        let gradientLayer = AngularGradientLayer()
//        if #available(iOS 12.0, *) {
//            let caGradientLayer = CAGradientLayer()
//            caGradientLayer.type = .conic
//            gradientLayer = caGradientLayer
//        } else {
//            return
////            gradientLayer = AngularGradientLayer()
//        }
        gradientLayer.colors = gradient.stops.map {
            $0.color.cgColor!
        }
        gradientLayer.locations = gradient.stops.map {
            $0.location
        }
        gradientLayer.center = center
        gradientLayer.startAngle = startAngle
        gradientLayer.endAngle = endAngle
    }
}

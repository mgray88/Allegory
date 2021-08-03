//
// Created by Mike on 7/31/21.
//

extension ShapeStyle where Self == Color {
    /// A context-dependent red color suitable for use in UI elements.
    public static var red: Color { Color.red }

    /// A context-dependent orange color suitable for use in UI elements.
    public static var orange: Color { Color.orange }

    /// A context-dependent yellow color suitable for use in UI elements.
    public static var yellow: Color { Color.yellow }

    /// A context-dependent green color suitable for use in UI elements.
    public static var green: Color { Color.green }

    /// A context-dependent blue color suitable for use in UI elements.
    public static var blue: Color { Color.blue }

    /// A context-dependent purple color suitable for use in UI elements.
    public static var purple: Color { Color.purple }

    /// A context-dependent pink color suitable for use in UI elements.
//    public static var pink: Color { Color.pink }

    /// A white color suitable for use in UI elements.
    public static var white: Color { Color.white }

    /// A context-dependent gray color suitable for use in UI elements.
    public static var gray: Color { Color.gray }

    /// A black color suitable for use in UI elements.
    public static var black: Color { Color.black }

    /// A clear color suitable for use in UI elements.
    public static var clear: Color { Color.clear }

    /// The color to use for primary content.
//    public static let primary: Color

    /// The color to use for secondary content.
//    public static let secondary: Color
}

extension Color: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        let color = cgColor
        layer.fillColor = color
        layer.strokeColor = color
    }
}

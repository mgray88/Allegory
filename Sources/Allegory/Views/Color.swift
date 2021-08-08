//
// Created by Mike on 7/29/21.
//

import UIKit

/// A representation of a color that adapts to a given context.
public struct Color: View, Hashable {

    public typealias Body = Never

    internal enum Storage: Hashable {
        case uiColor(color: UIColor)
        case rgba(red: Double, green: Double, blue: Double, opacity: Double)
        case hsb(hue: Double, saturation: Double, brightness: Double, opacity: Double)
        case asset(name: String, bundle: Bundle?)
    }

    internal let storage: Storage

    /// Creates a color from a color set that you indicate by name.
    ///
    /// Use this initializer to load a color from a color set stored in an Asset
    /// Catalog. The system determines which color within the set to use based
    /// on the environment at render time.
    ///
    /// - Parameters:
    ///   - name: The name of the color resource to look up.
    ///   - bundle: The bundle in which to search for the color resource. If you
    ///     don’t indicate a bundle, the initializer looks in your app’s main
    ///     bundle by default.
    @available(iOS 11, *)
    public init(_ name: String, bundle: Bundle? = nil) {
        storage = .asset(name: name, bundle: bundle)
    }

    /// Creates a constant color from hue, saturation, and brightness values.
    ///
    /// This initializer creates a constant color that doesn’t change based on
    /// context. For example, it doesn’t have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that you
    /// load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - hue: A value in the range 0 to 1 that maps to an angle from 0° to
    ///     360° to represent a shade on the color wheel.
    ///   - saturation: A value in the range 0 to 1 that indicates how strongly
    ///     the hue affects the color. A value of 0 removes the effect of the
    ///     hue, resulting in gray. As the value increases, the hue becomes more
    ///     prominent.
    ///   - brightness: A value in the range 0 to 1 that indicates how bright a
    ///     color is. A value of 0 results in black, regardless of the other
    ///     components. The color lightens as you increase this component.
    ///   - opacity: An optional degree of opacity, given in the range 0 to 1. A
    ///     value of 0 means 100% transparency, while a value of 1 means 100%
    ///     opacity. The default is 1.
    public init(
        hue: Double,
        saturation: Double,
        brightness: Double,
        opacity: Double = 1
    ) {
        storage = .hsb(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            opacity: opacity
        )
    }

    /// Creates a constant grayscale color.
    ///
    /// This initializer creates a constant color that doesn’t change based on
    /// context. For example, it doesn’t have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that you
    /// load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - white: A value that indicates how white the color is, with higher
    ///     values closer to 100% white, and lower values closer to 100% black.
    ///   - opacity: An optional degree of opacity, given in the range 0 to 1. A
    ///     value of 0 means 100% transparency, while a value of 1 means 100%
    ///     opacity. The default is 1.
    public init(white: Double, opacity: Double = 1) {
        storage = .rgba(red: white, green: white, blue: white, opacity: opacity)
    }

    /// Creates a constant color from red, green, and blue component values.
    ///
    /// This initializer creates a constant color that doesn’t change based on
    /// context. For example, it doesn’t have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that you
    /// load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - red: The amount of red in the color.
    ///   - green: The amount of green in the color.
    ///   - blue: The amount of blue in the color.
    ///   - opacity: An optional degree of opacity, given in the range 0 to 1. A
    ///     value of 0 means 100% transparency, while a value of 1 means 100%
    ///     opacity. The default is 1
    public init(red: Double, green: Double, blue: Double, opacity: Double = 1) {
        storage = .rgba(red: red, green: green, blue: blue, opacity: opacity)
    }

    /// Creates a color from a UIKit color.
    ///
    /// - Parameter uiColor: A `UIColor` instance from which to create a color.
    public init(uiColor: UIColor) {
        storage = .uiColor(color: uiColor)
    }
}

extension Color: ShapeStyle {}

extension Color {
    /// A context-dependent red color suitable for use in UI elements.
    public static let red = Color(uiColor: .red)

    /// A context-dependent orange color suitable for use in UI elements.
    public static let orange = Color(uiColor: .orange)

    /// A context-dependent yellow color suitable for use in UI elements.
    public static let yellow = Color(uiColor: .yellow)

    /// A context-dependent green color suitable for use in UI elements.
    public static let green = Color(uiColor: .green)

    /// A context-dependent blue color suitable for use in UI elements.
    public static let blue = Color(uiColor: .blue)

    /// A context-dependent purple color suitable for use in UI elements.
    public static let purple = Color(uiColor: .purple)

    /// A context-dependent pink color suitable for use in UI elements.
//    public static let pink = Color(uiColor: .pink)

    /// A white color suitable for use in UI elements.
    public static let white = Color(uiColor: .white)

    /// A context-dependent gray color suitable for use in UI elements.
    public static let gray = Color(uiColor: .gray)

    /// A black color suitable for use in UI elements.
    public static let black = Color(uiColor: .black)

    /// A clear color suitable for use in UI elements.
    public static let clear = Color(uiColor: .clear)

    /// The color to use for primary content.
//    public static let primary: Color

    /// The color to use for secondary content.
//    public static let secondary: Color
}

extension Color {
    public var uiColor: UIColor {
        switch storage {
        case let .uiColor(color: color):
            return color

        case let .rgba(red, green, blue, alpha):
            return UIColor(
                red: CGFloat(red),
                green: CGFloat(green),
                blue: CGFloat(blue),
                alpha: CGFloat(alpha)
            )

        case let .hsb(hue, saturation, brightness, opacity):
            return UIColor(
                hue: CGFloat(hue),
                saturation: CGFloat(saturation),
                brightness: CGFloat(brightness),
                alpha: CGFloat(opacity)
            )

        case let .asset(name, bundle):
            if #available(iOS 11.0, *) {
                return UIColor(named: name, in: bundle, compatibleWith: nil)!
            } else {
                fatalError("Color assets are not available on iOS 10 or earlier.")
            }
        }
    }

    public var cgColor: CGColor {
        uiColor.cgColor
    }
}

extension Color: UIKitNodeResolvable {

    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Color"
        }

        let layer = CALayer()

        func update(view: Color, context: Context) {
            layer.backgroundColor = view.uiColor.cgColor
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            proposedSize.orDefault
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            layer.frame = bounds.rect
            layer.removeAllAnimations()
            container.layer.addSublayer(layer)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

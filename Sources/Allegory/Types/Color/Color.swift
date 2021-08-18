//
// Created by Mike on 7/29/21.
//

import UIKit

/// A representation of a color that adapts to a given context.
public struct Color: Hashable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.provider == rhs.provider
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(provider)
    }

    @usableFromInline
    internal let provider: AnyColorBox

    @usableFromInline
    internal init(_ provider: AnyColorBox) {
        self.provider = provider
    }

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
    @inlinable
    public init(_ name: String, bundle: Bundle? = nil) {
        self.init(_AssetColorBox(name: name, bundle: bundle))
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
    @inlinable
    public init(
        hue: Double,
        saturation: Double,
        brightness: Double,
        opacity: Double = 1
    ) {
        let a = saturation * min(brightness / 2, 1 - (brightness / 2))
        let f = { (n: Int) -> Double in
            let k = Double((n + Int(hue * 12)) % 12)
            return brightness - (a * max(-1, min(k - 3, 9 - k, 1)))
        }
        self.init(.sRGB, red: f(0), green: f(8), blue: f(4), opacity: opacity)
    }

    /// Creates a constant grayscale color.
    ///
    /// This initializer creates a constant color that doesn’t change based on
    /// context. For example, it doesn’t have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that you
    /// load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the color
    ///     for display. The default is ``RGBColorSpace/sRGB``.
    ///   - white: A value that indicates how white the color is, with higher
    ///     values closer to 100% white, and lower values closer to 100% black.
    ///   - opacity: An optional degree of opacity, given in the range 0 to 1. A
    ///     value of 0 means 100% transparency, while a value of 1 means 100%
    ///     opacity. The default is 1.
    @inlinable
    public init(
        _ colorSpace: RGBColorSpace = .sRGB,
        white: Double,
        opacity: Double = 1
    ) {
        self.init(
            _ConcreteColorBox(
                .init(
                    white: white,
                    opacity: opacity,
                    space: colorSpace
                )
            )
        )
    }

    /// Creates a constant color from red, green, and blue component values.
    ///
    /// This initializer creates a constant color that doesn’t change based on
    /// context. For example, it doesn’t have distinct light and dark
    /// appearances, unlike various system-defined colors, or a color that you
    /// load from an Asset Catalog with ``init(_:bundle:)``.
    ///
    /// - Parameters:
    ///   - colorSpace: The profile that specifies how to interpret the color
    ///     for display. The default is ``RGBColorSpace/sRGB``.
    ///   - red: The amount of red in the color.
    ///   - green: The amount of green in the color.
    ///   - blue: The amount of blue in the color.
    ///   - opacity: An optional degree of opacity, given in the range 0 to 1. A
    ///     value of 0 means 100% transparency, while a value of 1 means 100%
    ///     opacity. The default is 1
    @inlinable
    public init(
        _ colorSpace: RGBColorSpace = .sRGB,
        red: Double,
        green: Double,
        blue: Double,
        opacity: Double = 1
    ) {
        self.init(
            _ConcreteColorBox(
                .init(
                    red: red,
                    green: green,
                    blue: blue,
                    opacity: opacity,
                    space: colorSpace
                )
            )
        )
    }

    /// Create a `Color` dependent on the current `ColorScheme`.
    @inlinable
    public static func _withScheme(
        _ resolver: @escaping (ColorScheme) -> Self
    ) -> Self {
        .init(_EnvironmentDependentColorBox {
            resolver($0.colorScheme)
        })
    }
}

extension Color {

    /// Creates a color from a Core Graphics color.
    ///
    /// - Parameter color: A
    ///   <doc://com.apple.documentation/documentation/CoreGraphics/CGColor> instance
    ///   from which to create a color.
    @inlinable
    public init(cgColor: CGColor) {
        self.init(_ConcreteColorBox(.init(cgColor: cgColor)))
    }

    /// A Core Graphics representation of the color, if available.
    ///
    /// You can get a
    /// <doc://com.apple.documentation/documentation/CoreGraphics/CGColor>
    /// instance from a constant Allegory color. This includes colors you create
    /// from a Core Graphics color, from RGB or HSB components, or from constant
    /// UIKit and AppKit colors.
    ///
    /// For a dynamic color, like one you load from an Asset Catalog using
    /// ``init(_:bundle:)``, or one you create from a dynamic UIKit or AppKit
    /// color, this property is `nil`.
    public var cgColor: CGColor? {
        provider.resolve(in: EnvironmentValues()).cgColor
    }
}

extension Color {

    /// Creates a color from a UIKit color.
    ///
    /// Use this method to create an Allegory color from a
    /// <doc://com.apple.documentation/documentation/UIKit/UIColor> instance.
    /// The new color preserves the adaptability of the original.
    /// For example, you can create a rectangle using
    /// <doc://com.apple.documentation/documentation/UIKit/UIColor/3173132-link>
    /// to see how the shade adjusts to match the user's system settings:
    ///
    ///     struct Box: View {
    ///         var body: some View {
    ///             Color(uiColor: .link)
    ///                 .frame(width: 200, height: 100)
    ///         }
    ///     }
    ///
    /// The `Box` view defined above automatically changes its
    /// appearance when the user turns on Dark Mode. With the light and dark
    /// appearances placed side by side, you can see the subtle difference
    /// in shades.
    ///
    /// > Note: Use this initializer only if you need to convert an existing
    /// <doc://com.apple.documentation/documentation/UIKit/UIColor> to an
    /// Allegory color. Otherwise, create an Allegory ``Color`` using an
    /// initializer like ``init(_:red:green:blue:opacity:)``, or use a system
    /// color like ``ShapeStyle/blue``.
    ///
    /// - Parameter color: A
    ///   <doc://com.apple.documentation/documentation/UIKit/UIColor> instance
    ///   from which to create a color.
    @inlinable
    public init(uiColor: UIColor) {
        self.init(_UIColorBox(uiColor: uiColor))
    }

    internal var uiColor: UIColor? {
        if let uiColorBox = provider as? _UIColorBox {
            return uiColorBox.uiColor
        } else {
            if let cgColor = provider.resolve(in: EnvironmentValues()).cgColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
    }
}

extension Color {

    /// Multiplies the opacity of the color by the given amount.
    ///
    /// - Parameter opacity: The amount by which to multiply the opacity of the
    ///   color.
    /// - Returns: A view with modified opacity.
    @inlinable
    public func opacity(_ opacity: Double) -> Self {
        Self(_OpacityColorBox(provider, opacity: opacity))
    }
}

extension Color {

    /// A profile that specifies how to interpret a color value for display.
    public enum RGBColorSpace {

        /// The extended red, green, blue (sRGB) color space.
        ///
        /// For information about the sRGB colorimetry and nonlinear
        /// transform function, see the IEC 61966-2-1 specification.
        ///
        /// Standard sRGB color spaces clamp the red, green, and blue
        /// components of a color to a range of `0` to `1`, but SwiftUI colors
        /// use an extended sRGB color space, so you can use component values
        /// outside that range.
        case sRGB

        /// The extended sRGB color space with a linear transfer function.
        ///
        /// This color space has the same colorimetry as ``sRGB``, but uses
        /// a linear transfer function.
        ///
        /// Standard sRGB color spaces clamp the red, green, and blue
        /// components of a color to a range of `0` to `1`, but SwiftUI colors
        /// use an extended sRGB color space, so you can use component values
        /// outside that range.
        case sRGBLinear

        /// The Display P3 color space.
        ///
        /// This color space uses the Digital Cinema Initiatives - Protocol 3
        /// (DCI-P3) primary colors, a D65 white point, and the ``sRGB``
        /// transfer function.
        case displayP3
    }
}

extension Color.RGBColorSpace {
    internal var cgColorSpace: CGColorSpace {
        switch self {
        case .sRGB:
            return .init(name: CGColorSpace.sRGB)!

        case .sRGBLinear:
            return .init(name: CGColorSpace.linearSRGB)!

        case .displayP3:
            return .init(name: CGColorSpace.displayP3)!
        }
    }
}

extension Color: CustomStringConvertible {
    public var description: String {
        if let providerDescription = provider as? CustomStringConvertible {
            return providerDescription.description
        } else {
            return "Color: \(provider.self)"
        }
    }
}

extension Color: ShapeStyle {
    public func _apply(to shape: inout _ShapeStyle_Shape) {
        shape.result = .color(self)
    }
}

extension Color: View {
    public var body: _ShapeView<Rectangle, Self> {
        _ShapeView(shape: Rectangle(), style: self)
    }
}

extension Color {
    private init(systemColor: _SystemColorBox.SystemColor) {
        self.init(_SystemColorBox(systemColor))
    }

    /// A context-dependent red color suitable for use in UI elements.
    public static let red = Color(systemColor: .red)

    /// A context-dependent orange color suitable for use in UI elements.
    public static let orange = Color(systemColor: .orange)

    /// A context-dependent yellow color suitable for use in UI elements.
    public static let yellow = Color(systemColor: .yellow)

    /// A context-dependent green color suitable for use in UI elements.
    public static let green = Color(systemColor: .green)

    /// A context-dependent blue color suitable for use in UI elements.
    public static let blue = Color(systemColor: .blue)

    /// A context-dependent purple color suitable for use in UI elements.
    public static let purple = Color(systemColor: .purple)

    /// A context-dependent pink color suitable for use in UI elements.
    public static let pink = Color(systemColor: .pink)

    /// A white color suitable for use in UI elements.
    public static let white = Color(systemColor: .white)

    /// A context-dependent gray color suitable for use in UI elements.
    public static let gray = Color(systemColor: .gray)

    /// A black color suitable for use in UI elements.
    public static let black = Color(systemColor: .black)

    /// A clear color suitable for use in UI elements.
    public static let clear = Color(systemColor: .clear)

    /// The color to use for primary content.
    public static let primary = Color(systemColor: .primary)

    /// The color to use for secondary content.
    public static let secondary = Color(systemColor: .secondary)
}

//extension Color: UIKitNodeResolvable {
//
//    private class Node: UIKitNode {
//
//        var hierarchyIdentifier: String {
//            "Color"
//        }
//
//        let layer = CALayer()
//
//        func update(view: Color, context: Context) {
//            let color = view.provider.resolve(in: context.environment).cgColor
//            layer.backgroundColor = color
//        }
//
//        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
//            proposedSize.orDefault
//        }
//
//        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
//            layer.frame = bounds.rect
//            layer.removeAllAnimations()
//            container.layer.addSublayer(layer)
//        }
//    }
//
//    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
//        (cachedNode as? Node) ?? Node()
//    }
//}

//
// Created by Mike on 8/14/21.
//

import UIKit.UIColor

public class AnyColorBox: AnyTokenBox, Hashable {
    public struct ResolvedColor: Hashable, Equatable {
        public let cgColor: CGColor?
        public init(
            red: Double,
            green: Double,
            blue: Double,
            opacity: Double,
            space: Color.RGBColorSpace
        ) {
            let comps = [red.cgFloat, green.cgFloat, blue.cgFloat, opacity.cgFloat]
            self.cgColor = CGColor(colorSpace: space.cgColorSpace, components: comps)
        }

        public init(
            white: Double,
            opacity: Double,
            space: Color.RGBColorSpace
        ) {
            self.init(
                red: white,
                green: white,
                blue: white,
                opacity: opacity,
                space: space
            )
        }

        public init(cgColor: CGColor?) {
            self.cgColor = cgColor
        }
    }

    public static func == (lhs: AnyColorBox, rhs: AnyColorBox) -> Bool {
        lhs.equals(rhs)
    }

    /// We use a function separate from `==` so that subclasses can override the equality checks.
    public func equals(_ other: AnyColorBox) -> Bool {
        abstractMethod("implement \(#function) in subclass")
    }

    public func hash(into hasher: inout Hasher) {
        abstractMethod("implement \(#function) in subclass")
    }

    public func resolve(in environment: EnvironmentValues) -> ResolvedColor {
        abstractMethod("implement \(#function) in subclass")
    }
}

@available(iOS 11, *)
public final class _AssetColorBox: AnyColorBox {
    public let name: String
    public let bundle: Bundle?

    @usableFromInline
    internal init(name: String, bundle: Bundle?) {
        self.name = name
        self.bundle = bundle
    }

    public override func equals(_ other: AnyColorBox) -> Bool {
        guard let other = other as? _AssetColorBox
        else { return false }
        return name == other.name && bundle == other.bundle
    }

    public override func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(bundle)
    }

    public override func resolve(
        in environment: EnvironmentValues
    ) -> ResolvedValue {
        let color = UIColor(named: name, in: bundle, compatibleWith: nil)
        return .init(cgColor: color?.cgColor)
    }
}

public final class _ConcreteColorBox: AnyColorBox {
    public let rgba: AnyColorBox.ResolvedColor

    override public func equals(_ other: AnyColorBox) -> Bool {
        guard let other = other as? _ConcreteColorBox
            else { return false }
        return rgba == other.rgba
    }

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(rgba)
    }

    @usableFromInline
    init(_ rgba: AnyColorBox.ResolvedColor) {
        self.rgba = rgba
    }

    override public func resolve(
        in environment: EnvironmentValues
    ) -> ResolvedValue {
        rgba
    }
}

public final class _EnvironmentDependentColorBox: AnyColorBox {
    public let resolver: (EnvironmentValues) -> Color

    override public func equals(_ other: AnyColorBox) -> Bool {
        guard let other = other as? _EnvironmentDependentColorBox
            else { return false }
        return resolver(EnvironmentValues()) ==
            other.resolver(EnvironmentValues())
    }

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(resolver(EnvironmentValues()))
    }

    @usableFromInline
    init(_ resolver: @escaping (EnvironmentValues) -> Color) {
        self.resolver = resolver
    }

    override public func resolve(
        in environment: EnvironmentValues
    ) -> ResolvedValue {
        resolver(environment).provider.resolve(in: environment)
    }
}

public final class _OpacityColorBox: AnyColorBox {
    public let parent: AnyColorBox
    public let opacity: Double

    override public func equals(_ other: AnyColorBox) -> Bool {
        guard let other = other as? _OpacityColorBox
            else { return false }
        return parent.equals(other.parent) && opacity == other.opacity
    }

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(parent)
        hasher.combine(opacity)
    }

    @usableFromInline
    init(_ parent: AnyColorBox, opacity: Double) {
        self.parent = parent
        self.opacity = opacity
    }

    override public func resolve(
        in environment: EnvironmentValues
    ) -> ResolvedValue {
        let resolved = parent.resolve(in: environment)
        return .init(cgColor: resolved.cgColor?.copy(alpha: opacity.cgFloat))
    }
}

public final class _SystemColorBox: AnyColorBox, CustomStringConvertible {
    public enum SystemColor: String, Equatable, Hashable {
        case clear
        case black
        case white
        case gray
        case red
        case green
        case blue
        case orange
        case yellow
        case pink
        case purple
        case primary
        case secondary
    }

    public var description: String {
        value.rawValue
    }

    public let value: SystemColor

    override public func equals(_ other: AnyColorBox) -> Bool {
        guard let other = other as? _SystemColorBox
            else { return false }
        return value == other.value
    }

    override public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    init(_ value: SystemColor) {
        self.value = value
    }

    override public func resolve(
        in environment: EnvironmentValues
    ) -> ResolvedValue {
        switch environment.colorScheme {
        case .light:
            switch value {
            case .clear: return .init(red: 0, green: 0, blue: 0, opacity: 0, space: .sRGB)
            case .black: return .init(red: 0, green: 0, blue: 0, opacity: 1, space: .sRGB)
            case .white: return .init(red: 1, green: 1, blue: 1, opacity: 1, space: .sRGB)
            case .gray: return .init(red: 0.55, green: 0.55, blue: 0.57, opacity: 1, space: .sRGB)
            case .red: return .init(red: 1, green: 0.23, blue: 0.19, opacity: 1, space: .sRGB)
            case .green: return .init(red: 0.21, green: 0.78, blue: 0.35, opacity: 1, space: .sRGB)
            case .blue: return .init(red: 0.01, green: 0.48, blue: 1, opacity: 1, space: .sRGB)
            case .orange: return .init(red: 1, green: 0.58, blue: 0, opacity: 1, space: .sRGB)
            case .yellow: return .init(red: 1, green: 0.8, blue: 0, opacity: 1, space: .sRGB)
            case .pink: return .init(red: 1, green: 0.17, blue: 0.33, opacity: 1, space: .sRGB)
            case .purple: return .init(red: 0.69, green: 0.32, blue: 0.87, opacity: 1, space: .sRGB)
            case .primary: return .init(red: 0, green: 0, blue: 0, opacity: 1, space: .sRGB)
            case .secondary: return .init(red: 0.55, green: 0.55, blue: 0.57, opacity: 1, space: .sRGB)
            }
        case .dark:
            switch value {
            case .clear: return .init(red: 0, green: 0, blue: 0, opacity: 0, space: .sRGB)
            case .black: return .init(red: 0, green: 0, blue: 0, opacity: 1, space: .sRGB)
            case .white: return .init(red: 1, green: 1, blue: 1, opacity: 1, space: .sRGB)
            case .gray: return .init(red: 0.55, green: 0.55, blue: 0.57, opacity: 1, space: .sRGB)
            case .red: return .init(red: 1, green: 0.27, blue: 0.23, opacity: 1, space: .sRGB)
            case .green: return .init(red: 0.19, green: 0.82, blue: 0.35, opacity: 1, space: .sRGB)
            case .blue: return .init(red: 0.04, green: 0.52, blue: 1.00, opacity: 1, space: .sRGB)
            case .orange: return .init(red: 1, green: 0.62, blue: 0.04, opacity: 1, space: .sRGB)
            case .yellow: return .init(red: 1, green: 0.84, blue: 0.04, opacity: 1, space: .sRGB)
            case .pink: return .init(red: 1, green: 0.22, blue: 0.37, opacity: 1, space: .sRGB)
            case .purple: return .init(red: 0.75, green: 0.35, blue: 0.95, opacity: 1, space: .sRGB)
            case .primary: return .init(red: 1, green: 1, blue: 1, opacity: 1, space: .sRGB)
            case .secondary: return .init(red: 0.55, green: 0.55, blue: 0.57, opacity: 1, space: .sRGB)
            }
        }
    }
}

public final class _UIColorBox: AnyColorBox {
    public let uiColor: UIColor

    @usableFromInline
    internal init(uiColor: UIColor) {
        self.uiColor = uiColor
    }

    public override func equals(_ other: AnyColorBox) -> Bool {
        guard let other = other as? _UIColorBox else { return false }
        return other.uiColor == uiColor
    }

    public override func hash(into hasher: inout Hasher) {
        hasher.combine(uiColor)
    }

    public override func resolve(
        in environment: EnvironmentValues
    ) -> ResolvedValue {
        .init(cgColor: uiColor.cgColor)
    }
}

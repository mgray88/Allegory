//
// Created by Mike on 7/30/21.
//
import UIKit

/// An environment-dependent font.
public struct Font: Hashable {

    public enum Descriptor: Hashable {

        public struct Attributes: Hashable {
            public var isItalic: Bool = false
            public var isSsmallCaps: Bool = false
            public var isLowercaseSmallCaps: Bool = false
            public var isUppercaseSmallCaps: Bool = false
            public var isMonospacedDigit: Bool = false
            public var isBold: Bool = false

            @inlinable
            public init() {}
        }

        case system(size: CGFloat, weight: Weight, design: Design, attributes: Attributes)
        case systemStyle(style: Font.TextStyle, attributes: Attributes)
        case custom(name: String, size: CGFloat)
    }

    public var descriptor: Descriptor

    @inlinable
    internal init(descriptor: Descriptor) {
        self.descriptor = descriptor
    }

    /// Adds italics to the font.
    @inlinable
    public func italic() -> Font {
        Font(descriptor: descriptor.modifyingAttributes { $0.isItalic = true })
    }

    /// Adjusts the font to enable all small capitals.
    @inlinable
    public func smallCaps() -> Font {
        Font(descriptor: descriptor.modifyingAttributes { $0.isSsmallCaps = true })
    }

    /// Adjusts the font to enable lowercase small capitals.
    @inlinable
    public func lowercaseSmallCaps() -> Font {
        Font(descriptor: descriptor.modifyingAttributes { $0.isLowercaseSmallCaps = true })
    }

    /// Adjusts the font to enable uppercase small capitals.
    @inlinable
    public func uppercaseSmallCaps() -> Font {
        Font(descriptor: descriptor.modifyingAttributes { $0.isUppercaseSmallCaps = true })
    }

    /// Adjusts the font to use monospace digits.
    @inlinable
    public func monospacedDigit() -> Font {
        Font(descriptor: descriptor.modifyingAttributes { $0.isMonospacedDigit = true })
    }

    /// Sets the weight of the font.
    @inlinable
    public func weight(_ weight: Font.Weight) -> Font {
        Font(descriptor: descriptor.modifyingWeight(weight))
    }

    /// Adds bold styling to the font.
    @inlinable
    public func bold() -> Font {
        Font(descriptor: descriptor.modifyingAttributes { $0.isBold = true })
    }

    /// A weight to use for fonts.
    public struct Weight: Equatable, Hashable {
        public let uiFontWeight: UIFont.Weight

        public static let ultraLight = Weight(uiFontWeight: .ultraLight)

        public static let thin = Weight(uiFontWeight: .thin)

        public static let light = Weight(uiFontWeight: .light)

        public static let regular = Weight(uiFontWeight: .regular)

        public static let medium = Weight(uiFontWeight: .medium)

        public static let semibold = Weight(uiFontWeight: .semibold)

        public static let bold = Weight(uiFontWeight: .bold)

        public static let heavy = Weight(uiFontWeight: .heavy)

        public static let black = Weight(uiFontWeight: .black)
    }
}

extension Font {

    /// A font with the large title text style.
    public static let largeTitle: Font = .system(.largeTitle)

    /// A font with the title text style.
    public static let title: Font = .system(.title)

    /// Create a font for second level hierarchical headings.
    public static let title2: Font = .system(.title2)

    /// Create a font for third level hierarchical headings.
    public static let title3: Font = .system(.title3)

    /// A font with the headline text style.
    public static var headline: Font = .system(.headline)

    /// A font with the subheadline text style.
    public static var subheadline: Font = .system(.subheadline)

    /// A font with the body text style.
    public static var body: Font = .system(.body)

    /// A font with the callout text style.
    public static var callout: Font = .system(.callout)

    /// A font with the caption text style.
    public static var caption: Font = .system(.caption)

    /// Create a font with the alternate caption text style.
    public static var caption2: Font = .system(.caption2)

    /// A font with the footnote text style.
    public static var footnote: Font = .system(.footnote)

    /// Gets a system font with the given style and design.
    @inlinable
    public static func system(_ style: Font.TextStyle) -> Font {
        Font(descriptor: .systemStyle(style: style, attributes: .init()))
    }

    /// Specifies a system font to use, along with the style, weight, and any
    /// design parameters you want applied to the text.
    @inlinable
    public static func system(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        Font(descriptor: .system(size: CGFloat(size), weight: weight, design: design, attributes: .init()))
    }

    /// Create a custom font with the given name and size that scales with the
    /// body text style.
    @inlinable
    public static func custom(_ name: String, size: Double) -> Font {
        Font(descriptor: .custom(name: name, size: CGFloat(size)))
    }

    /// A dynamic text style to use for fonts.
    public enum TextStyle: CaseIterable, Equatable, Hashable {
        /// The font style for large titles.
        case largeTitle

        /// The font used for first level hierarchical headings.
        case title

        /// The font used for second level hierarchical headings.
        case title2

        /// The font used for third level hierarchical headings.
        case title3

        /// The font used for headings.
        case headline

        /// The font used for subheadings.
        case subheadline

        /// The font used for body text.
        case body

        /// The font used for callouts.
        case callout

        /// The font used in footnotes.
        case footnote

        /// The font used for standard captions.
        case caption

        /// The font used for alternate captions.
        case caption2
    }

    /// A design to use for fonts.
    public enum Design : Equatable, Hashable {
        case `default`
        case serif
        case rounded
        case monospaced
    }
}

extension Font.Descriptor {

    @inlinable
    internal func modifyingAttributes(_ modify: (inout Attributes) -> Void) -> Font.Descriptor {
        switch self {
        case .system(size: let size, let weight, let design, var attributes):
            modify(&attributes)
            return .system(size: size, weight: weight, design: design, attributes: attributes)

        case .systemStyle(style: let style, var attributes):
            modify(&attributes)
            return .systemStyle(style: style, attributes: attributes)

        case .custom(let name, let size):
            return .custom(name: name, size: size)
        }
    }

    @inlinable
    internal func modifyingWeight(_ newWeight: Font.Weight) -> Font.Descriptor {
        switch self {
        case .system(let size, _, let design, let attributes):
            return .system(size: size, weight: newWeight, design: design, attributes: attributes)

        case .systemStyle(let style, let attributes):
            return .systemStyle(style: style, attributes: attributes)

        case .custom(let name, let size):
            return .custom(name: name, size: size)
        }
    }
}

extension Font.Descriptor {
    private static var cache: [Font.Descriptor: UIFont] = [:]

    var uiFont: UIFont {
        if let font = Self.cache[self] {
            return font
        }
        let font: UIFont
        switch self {
        case .system(let size, var weight, let design, let attributes):
            // TODO: improve mapping
            if attributes.isBold {
                weight = .bold
            }
            switch design {
            case .default:
                font = .systemFont(ofSize: size, weight: weight.uiFontWeight)
            case .monospaced:
                if #available(iOS 13.0, *) {
                    font = .monospacedSystemFont(ofSize: size, weight: weight.uiFontWeight)
                } else {
                    font = .monospacedDigitSystemFont(ofSize: size, weight: weight.uiFontWeight)
                }
            default:
                notSupported()
            }

        case .systemStyle(let style, _):
            font = UIFont.preferredFont(forTextStyle: style.uiTextStyle)

        case .custom(let name, let size):
            font = UIFont(name: name, size: size)!
        }
        Self.cache[self] = font
        return font
    }
}

extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            if #available(iOS 11.0, *) {
                return .largeTitle
            } else {
                return .title1
            }

        case .title:
            return .title1

        case .title2:
            return .title2

        case .title3:
            return .title3

        case .headline:
            return .headline

        case .subheadline:
            return .subheadline

        case .body:
            return .body

        case .callout:
            return .callout

        case .footnote:
            return .footnote

        case .caption:
            return .caption1

        case .caption2:
            return .caption2
        }
    }
}

extension Font {
    var uiFont: UIFont {
        descriptor.uiFont
    }
}

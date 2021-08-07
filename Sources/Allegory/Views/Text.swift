//
// Created by Mike on 7/29/21.
//

import UIKit

public struct Text: View, Hashable {

    public typealias Body = Swift.Never

    public let storage: Storage

    /// Creates a text view that displays a stored string without localization.
    ///
    /// - Parameter content: The string value to display without localization.
    public init<S>(_ content: S) where S: StringProtocol {
        self.storage = .plain(String(content))
    }

    @inlinable
    internal init(_ storage: Storage) {
        self.storage = storage
    }

    @inlinable
    public static func + (lhs: Text, rhs: Text) -> Text {
        Text(Storage.concatenated(lhs.storage, rhs.storage))
    }
}

extension Text {
    public enum Attribute: Hashable {
        case foregroundColor(Color?)
        case font(Font?)
        case fontWeight(Font.Weight?)
        case bold
        case italic
        case strikethrough(active: Bool, color: Color?)
        case underline(active: Bool, color: Color?)
        case kerning(CGFloat?)
        case tracking(CGFloat?)
        case baselineOffset(CGFloat?)
    }

    public indirect enum Storage: Hashable {
        case plain(String)
        case attributed(Storage, Attribute)
        case concatenated(Storage, Storage)
    }

    /// Sets the default font for text in the view.
    ///
    /// - Parameter font: The font to use when displaying this text.
    /// - Returns: Text that uses the font you specify.
    ///
    /// Use `font(_:)` to apply a specific font to an individual Text View, or
    /// all of the text views in a container.
    @inlinable
    public func font(_ font: Font?) -> Text {
        Text(.attributed(storage, .font(font)))
    }

    /// Sets the font weight of the text.
    ///
    /// - Parameter weight: One of the available font weights.
    /// - Returns: Text that uses the font weight you specify.
    @inlinable
    public func fontWeight(_ weight: Font.Weight?) -> Text {
        Text(.attributed(storage, .fontWeight(weight)))
    }

    /// Sets the color of the text displayed by this view.
    ///
    /// - Parameter color: The color to use when displaying this text.
    /// - Returns: A text view that uses the color value you supply.
    @inlinable
    public func foregroundColor(_ color: Color?) -> Text {
        Text(.attributed(storage, .foregroundColor(color)))
    }

    /// Applies a bold font weight to the text.
    ///
    /// - Returns: Bold text.
    @inlinable
    public func bold() -> Text {
        Text(.attributed(storage, .bold))
    }

    /// Applies italics to the text.
    ///
    /// - Returns: Italic text.
    @inlinable
    public func italic() -> Text {
        Text(.attributed(storage, .italic))
    }

    /// Applies a strikethrough to the text.
    ///
    /// - Parameters:
    ///   - active: A Boolean value that indicates whether the text has a
    ///     strikethrough applied.
    ///   - color: The color of the strikethrough. If `color` is `nil`, the
    ///     strikethrough uses the default foreground color.
    /// - Returns: Text with a line through its center.
    @inlinable
    public func strikethrough(_ active: Bool = true, color: Color? = nil) -> Text {
        Text(.attributed(storage, .strikethrough(active: active, color: color)))
    }

    /// Applies an underline to the text.
    ///
    /// - Parameters:
    ///   - active: A Boolean value that indicates whether the text has an
    ///     underline.
    ///   - color: The color of the underline. If `color` is `nil`, the
    ///     underline uses the default foreground color.
    /// - Returns: Text with a line running along its baseline.
    @inlinable
    public func underline(_ active: Bool = true, color: Color? = nil) -> Text {
        Text(.attributed(storage, .underline(active: active, color: color)))
    }

    /// Sets the spacing, or kerning, between characters.
    ///
    /// Kerning defines the offset, in points, that a text view should shift
    /// characters from the default spacing. Use positive kerning to widen the
    /// spacing between characters. Use negative kerning to tighten the spacing
    /// between characters.
    ///
    /// - Parameter kerning: The spacing to use between individual characters in
    ///   this text.
    /// - Returns: Text with the specified amount of kerning.
    @inlinable
    public func kerning(_ kerning: Double) -> Text {
        Text(.attributed(storage, .kerning(CGFloat(kerning))))
    }

    /// Sets the tracking for the text.
    ///
    /// > Warning: This is not implemented as it is only supported in iOS 14+
    ///
    /// Tracking adds space, measured in points, between the characters in the
    /// text view. A positive value increases the spacing between characters,
    /// while a negative value brings the characters closer together.
    ///
    /// The effect of tracking resembles that of the ``kerning(_:)`` modifier,
    /// but adds or removes trailing whitespace, rather than changing character
    /// offsets. Also, using any nonzero amount of tracking disables
    /// nonessential ligatures, whereas kerning attempts to maintain ligatures.
    ///
    /// > Important: If you add both the ``tracking(_:)`` and ``kerning(_:)``
    ///   modifiers to a view, the view applies the tracking and ignores the
    ///   kerning.
    ///
    /// - Parameter tracking: The amount of additional space, in points, that
    ///   the view should add to each character cluster after layout.
    /// - Returns: Text with the specified amount of tracking.
    @inlinable
    public func tracking(_ tracking: Double) -> Text {
        notSupported()
    }

    /// Sets the vertical offset for the text relative to its baseline.
    ///
    /// Change the baseline offset to move the text in the view (in points) up
    /// or down relative to its baseline. The bounds of the view expand to
    /// contain the moved text.
    ///
    /// - Parameter baselineOffset: The amount to shift the text vertically (up
    ///   or down) relative to its baseline.
    /// - Returns: Text that’s above or below its baseline.
    @inlinable
    public func baselineOffset(_ baselineOffset: Double) -> Text {
        Text(.attributed(storage, .baselineOffset(CGFloat(baselineOffset))))
    }
}

extension Text {
    /// The type of truncation to apply to a line of text when it’s too long to
    /// fit in the available space.
    ///
    /// When a text view contains more text than it’s able to display, the view
    /// might truncate the text and place an ellipsis (…) at the truncation
    /// point. Use the ``truncationMode(_:)`` modifier with one of the
    /// `TruncationMode` values to indicate which part of the text to truncate,
    /// either at the beginning, in the middle, or at the end.
    public enum TruncationMode: Equatable, Hashable {
        /// Truncate at the beginning of the line.
        case head

        /// Truncate in the middle of the line.
        case middle

        /// Truncate at the end of the line.
        case tail
    }
}

extension Text: UIKitNodeResolvable {
    private class Node: UIKitNode {

        var hierarchyIdentifier: String {
            "Text"
        }

        var text: Text?
        var env: EnvironmentValues?
        var cache = GeometryCache()

        let label = UILabel()

        func update(view: Text, context: Context) {
            (text, env) = (view, context.environment)
            label.configure(with: view.storage, env: context.environment)
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            guard let text = text, let env = env else { return .zero }
            let proposedSize = proposedSize.orMax
            if let geometry = cache.geometry(for: pass, size: proposedSize) {
                return geometry.idealSize
            }
            let size = text.storage.boundingSize(fitting: proposedSize, env: env)
            cache.update(
                pass: pass,
                size: proposedSize,
                geometry: ContentGeometry(idealSize: size, frames: [])
            )
            return size
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            container.view.addSubview(label)
            label.frame = bounds.rect
            label.accessibilityFrame = label.convert(bounds.rect, to: nil)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

extension Text.Storage {
    var stringValue: String {
        switch self {
        case let .plain(stringValue):
            return stringValue

        case let .attributed(storage, _):
            return storage.stringValue

        case let .concatenated(lhs, rhs):
            return lhs.stringValue + rhs.stringValue
        }
    }

    func attributedStringValue(baseFont: Font) -> NSAttributedString {
        let string = NSMutableAttributedString()
        string.parse(self, font: baseFont, attributes: [.font: baseFont.uiFont])
        return string
    }

    var isAttributed: Bool {
        switch self {
        case .plain:
            return false

        case .attributed:
            return true

        case let .concatenated(lhs, rhs):
            return lhs.isAttributed || rhs.isAttributed
        }
    }
}

extension Text.Storage {

    func boundingSize(fitting size: CGSize, env: EnvironmentValues) -> CGSize {
        if isAttributed {

            return attributedStringValue(baseFont: env.font).boundingRect(
                with: max(size, .zero),
                options: [.usesLineFragmentOrigin],
                context: nil
            ).size
        } else {
            let nsString = stringValue as NSString
            let font = env.font.descriptor.uiFont
            return nsString.boundingRect(
                with: max(size, .zero),
                options: [.usesLineFragmentOrigin],
                attributes: [.font: font],
                context: nil
            ).size
        }
    }
}

extension UILabel {
    func configure(with storage: Text.Storage, env: EnvironmentValues) {
        // TODO
        font = env.font.descriptor.uiFont
        numberOfLines = env.lineLimit ?? 0
        minimumScaleFactor = CGFloat(env.minimumScaleFactor)
        adjustsFontSizeToFitWidth = minimumScaleFactor != 1
        textColor = env.foregroundColor?.uiColor

        switch env.multilineTextAlignment {
        case .leading:
            textAlignment = .left

        case .center:
            textAlignment = .center

        case .trailing:
            textAlignment = .right
        }

        switch env.truncationMode {
        case .head:
            lineBreakMode = .byTruncatingHead

        case .middle:
            lineBreakMode = .byTruncatingMiddle

        case .tail:
            lineBreakMode = .byTruncatingTail
        }

        if storage.isAttributed {
            attributedText = storage.attributedStringValue(baseFont: env.font)
        } else {
            text = storage.stringValue
        }
    }
}

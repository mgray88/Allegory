//
// Created by Mike on 7/30/21.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    func parse(_ storage: Text.Storage, font: Font, attributes: [NSAttributedString.Key: Any]?) {
        switch storage {
        case let .plain(string):
            append(NSAttributedString(string: string, attributes: attributes))
        case let .concatenated(lhs, rhs):
            parse(lhs, font: font, attributes: attributes)
            parse(rhs, font: font, attributes: attributes)
        case let .attributed(storage, attribute):
            var attributes = attributes ?? [:]
            switch attribute {
            case let .foregroundColor(color):
                attributes[.foregroundColor] = color?.uiColor

            case let .font(font):
                attributes[.font] = font?.uiFont

            case let .fontWeight(weight):
                attributes[.font] = font.weight(weight ?? .regular).uiFont

            case .bold:
                attributes[.font] = font.bold().uiFont

            case .italic:
                attributes[.font] = font.italic().uiFont

            case let .strikethrough(active, color):
                attributes[.strikethroughStyle] = NSNumber(value: active ? NSUnderlineStyle.single.rawValue : 0)
                attributes[.strikethroughColor] = active ? color?.uiColor : nil

            case let .underline(active, color):
                attributes[.underlineStyle] = NSNumber(value: active ? NSUnderlineStyle.single.rawValue : 0)
                attributes[.underlineColor] = color?.uiColor

            case let .kerning(kerning):
                attributes[.kern] = kerning.map { NSNumber(value: Float($0)) }

            case .tracking:
                notSupported()

            case let .baselineOffset(baselineOffset):
                attributes[.baselineOffset] = baselineOffset.map { NSNumber(value: Float($0)) }
            }
            parse(storage, font: font, attributes: attributes)
        }
    }
}

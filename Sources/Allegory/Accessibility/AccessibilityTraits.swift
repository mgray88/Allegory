//
// Created by Mike on 8/29/21.
//

import UIKit

public struct AccessibilityTraits: SetAlgebra {
    @_spi(Internal)
    public var rawValue: UIAccessibilityTraits

    public static let isButton: AccessibilityTraits = .init(.button)
    public static let isHeader: AccessibilityTraits = .init(.header)
    public static let isSelected: AccessibilityTraits = .init(.selected)
    public static let isLink: AccessibilityTraits = .init(.link)
    public static let isSearchField: AccessibilityTraits = .init(.searchField)
    public static let isImage: AccessibilityTraits = .init(.image)
    public static let playsSound: AccessibilityTraits = .init(.playsSound)
    public static let isKeyboardKey: AccessibilityTraits = .init(.keyboardKey)
    public static let isStaticText: AccessibilityTraits = .init(.staticText)
    public static let isSummaryElement: AccessibilityTraits = .init(.summaryElement)
    public static let updatesFrequently: AccessibilityTraits = .init(.updatesFrequently)
    public static let startsMediaSession: AccessibilityTraits = .init(.startsMediaSession)
    public static let allowsDirectInteraction: AccessibilityTraits = .init(.allowsDirectInteraction)
    public static let causesPageTurn: AccessibilityTraits = .init(.causesPageTurn)
    // public static let isModal: AccessibilityTraits

    public init() {
        rawValue = .init()
    }

    public func union(_ other: AccessibilityTraits) -> AccessibilityTraits {
        .init(rawValue.union(other.rawValue))
    }

    public mutating func formUnion(_ other: AccessibilityTraits) {
        rawValue.formUnion(other.rawValue)
    }

    public func intersection(
        _ other: AccessibilityTraits
    ) -> AccessibilityTraits {
        .init(rawValue: rawValue.intersection(other.rawValue))
    }

    public mutating func formIntersection(_ other: AccessibilityTraits) {
        rawValue.formIntersection(other.rawValue)
    }

    public func symmetricDifference(
        _ other: AccessibilityTraits
    ) -> AccessibilityTraits {
        .init(rawValue.symmetricDifference(other.rawValue))
    }

    public mutating func formSymmetricDifference(_ other: AccessibilityTraits) {
        rawValue.formSymmetricDifference(other.rawValue)
    }

    public func contains(_ member: AccessibilityTraits) -> Bool {
        rawValue.contains(member.rawValue)
    }

    public mutating func insert(
        _ newMember: AccessibilityTraits
    ) -> (inserted: Bool, memberAfterInsert: AccessibilityTraits) {
        let result = rawValue.insert(newMember.rawValue)
        return (result.inserted, .init(result.memberAfterInsert))
    }

    public mutating func remove(
        _ member: AccessibilityTraits
    ) -> AccessibilityTraits? {
        rawValue.remove(member.rawValue).map { .init($0) }
    }

    public mutating func update(
        with newMember: AccessibilityTraits
    ) -> AccessibilityTraits? {
        rawValue.update(with: newMember.rawValue).map { .init($0) }
    }

    public static func == (
        a: AccessibilityTraits,
        b: AccessibilityTraits
    ) -> Bool {
        a.rawValue == b.rawValue
    }

    public typealias ArrayLiteralElement = AccessibilityTraits

    public typealias Element = AccessibilityTraits
}

extension AccessibilityTraits: OptionSet {
    @_spi(Internal)
    public init(rawValue: UIAccessibilityTraits) {
        self.rawValue = rawValue
    }

    @_spi(Internal)
    public init(_ uiAccessibilityTrait: UIAccessibilityTraits) {
        self.init(rawValue: uiAccessibilityTrait)
    }
}

extension View {
    public func accessibilityAddTraits(
        _ traits: AccessibilityTraits
    ) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        modifier(
            .init {
                $0.accessibilityTraits.formUnion(traits.rawValue)
            }
        )
    }

    public func accessibilityRemoveTraits(
        _ traits: AccessibilityTraits
    ) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        modifier(
            .init {
                $0.accessibilityTraits.formIntersection(traits.rawValue)
            }
        )
    }
}

extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
    public func accessibilityAddTraits(
        _ traits: AccessibilityTraits
    ) -> ModifiedContent<Content, Modifier> {
        TODO()
    }

    public func accessibilityRemoveTraits(
        _ traits: AccessibilityTraits
    ) -> ModifiedContent<Content, Modifier> {
        TODO()
    }
}

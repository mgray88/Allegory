//
// Created by Mike on 9/5/21.
//

import UIKit

extension UIView: Accessibility {
    var _accessibilityTraits: AccessibilityTraits {
        get {
            .init(accessibilityTraits)
        }
        set {
            accessibilityTraits = newValue.rawValue
        }
    }
}

protocol Accessibility: AnyObject {
    var isAccessibilityElement: Bool { get set }
    var accessibilityLabel: String? { get set }
    var accessibilityValue: String? { get set }
    var accessibilityHint: String? { get set }
    var accessibilityTraits: UIAccessibilityTraits { get set }
    var _accessibilityTraits: AccessibilityTraits { get set }
    @available(iOS 11, *)
    var accessibilityAttributedHint: NSAttributedString? { get set }
    @available(iOS 11, *)
    var accessibilityAttributedLabel: NSAttributedString? { get set }
    @available(iOS 11, *)
    var accessibilityAttributedValue: NSAttributedString? { get set }
    var accessibilityLanguage: String? { get set }
    var accessibilityElementsHidden: Bool { get set }
    @available(iOS 13, *)
    var accessibilityRespondsToUserInteraction: Bool { get set }
    var accessibilityViewIsModal: Bool { get set }
    var shouldGroupAccessibilityChildren: Bool { get set }
}

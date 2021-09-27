//
// Created by Mike on 8/29/21.
//

import UIKit

public struct AccessibilityAttachmentModifier: ViewModifier {
    public typealias Body = Swift.Never

    private let modifier: (Accessibility) -> Void

    internal init(_ modifier: @escaping (Accessibility) -> Void) {
        self.modifier = modifier
    }
}

extension View {
    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that
    /// doesn't display text, like an icon. For example, you could use this
    /// method to label a button that plays music with the text "Play". Don't
    /// include text in the label that repeats information that users already
    /// have. For example, don't use the label "Play button" because a button
    /// already has a trait that identifies it as a button.
    public func accessibilityLabel(
        _ label: Text
    ) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        modifier(
            .init {
                $0.accessibilityLabel = label.storage.stringValue
            }
        )
    }
}

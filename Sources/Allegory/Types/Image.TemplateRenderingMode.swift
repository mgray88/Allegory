//
// Created by Mike on 8/3/21.
//

extension Image {
    /// A type that indicates how SwiftUI renders images.
    public enum TemplateRenderingMode: Hashable {
        /// A mode that renders all non-transparent pixels as the foreground
        /// color.
        case template

        /// A mode that renders pixels of bitmap images as-is.
        ///
        /// For system images created from the SF Symbol set, multicolor symbols
        /// respect the current foreground and accent colors.
        case original
    }
}

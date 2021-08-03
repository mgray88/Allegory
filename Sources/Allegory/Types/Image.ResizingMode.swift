//
// Created by Mike on 8/3/21.
//

import UIKit.UIImage

extension Image {
    /// The modes that SwiftUI uses to resize an image to fit within its containing view.
    public enum ResizingMode: Hashable {
        /// A mode to repeat the image at its original size, as many times as
        /// necessary to fill the available space.
        case tile

        /// A mode to enlarge or reduce the size of an image so that it fills the available space.
        case stretch
    }
}

extension Image.ResizingMode {
    internal var uiImageResizingMode: UIImage.ResizingMode {
        switch self {
        case .tile: return .tile
        case .stretch: return .stretch
        }
    }
}

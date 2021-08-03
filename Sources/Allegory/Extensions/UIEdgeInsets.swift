//
// Created by Mike on 7/30/21.
//

import UIKit

extension EdgeInsets {
    init(_ insets: UIEdgeInsets) {
        self.init(
            top: Double(insets.top),
            leading: Double(insets.left),
            bottom: Double(insets.bottom),
            trailing: Double(insets.right)
        )
    }

    internal var uiEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: top.cgFloat,
            left: left.cgFloat,
            bottom: bottom.cgFloat,
            right: right.cgFloat
        )
    }
}

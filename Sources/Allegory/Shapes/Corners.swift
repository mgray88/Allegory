//
// Created by Mike on 8/5/21.
//

import UIKit

public struct Corners: Shape, Equatable {
    public let radius: Double
    public let corners: UIRectCorner

    public init(radius: Double, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: CGFloat(radius),
                height: CGFloat(radius)
            )
        )
        return Path(path.cgPath)
    }
}

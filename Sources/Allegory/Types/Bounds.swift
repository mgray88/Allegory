//
// Created by Mike on 7/29/21.
//

public struct Bounds {
    public let rect: CGRect
    public let safeAreaInsets: EdgeInsets

    public init(rect: CGRect, safeAreaInsets: EdgeInsets) {
        self.rect = rect
        self.safeAreaInsets = safeAreaInsets
    }
}

extension Bounds {

    @inlinable
    public var origin: CGPoint {
        rect.origin
    }

    @inlinable
    public var size: CGSize {
        rect.size
    }

    public func unsafe(edges: Edge.Set = .all) -> Bounds {
        Bounds(
            rect: unsafeRect(edges: edges),
            safeAreaInsets: EdgeInsets(
                top: edges.contains(.top) ? 0 : safeAreaInsets.top,
                leading: edges.contains(.leading) ? 0 : safeAreaInsets.leading,
                bottom: edges.contains(.bottom) ? 0 : safeAreaInsets.bottom,
                trailing: edges.contains(.trailing) ? 0 : safeAreaInsets.trailing
            )
        )
    }

    public func unsafeRect(edges: Edge.Set = .all) -> CGRect {
        rect.inset(
            by: EdgeInsets(
               top: edges.contains(.top) ? -safeAreaInsets.top : 0,
               leading: edges.contains(.leading) ? -safeAreaInsets.leading : 0,
               bottom: edges.contains(.bottom) ? -safeAreaInsets.bottom : 0,
               trailing: edges.contains(.trailing) ? -safeAreaInsets.trailing : 0
           )
        )
    }

    public func at(origin: CGPoint) -> Bounds {
        Bounds(
            rect: CGRect(origin: origin, size: rect.size),
            safeAreaInsets: safeAreaInsets // TODO
        )
    }

    public func offset(dx: CGFloat, dy: CGFloat) -> Bounds {
        Bounds(
            rect: rect.offsetBy(dx: dx, dy: dy),
            safeAreaInsets: safeAreaInsets // TODO
        )
    }

    public func inset(by insets: EdgeInsets) -> Bounds {
        Bounds(
            rect: rect.inset(by: insets),
            safeAreaInsets: EdgeInsets(
                top: max(0, safeAreaInsets.top - insets.top),
                leading: max(0, safeAreaInsets.leading - insets.leading),
                bottom: max(0, safeAreaInsets.bottom - insets.bottom),
                trailing: max(0, safeAreaInsets.trailing - insets.trailing)
            )
        )
    }

    public func update(to newRect: CGRect) -> Bounds {
        Bounds(
            rect: newRect,
            safeAreaInsets: safeAreaInsets // TODO
        )
    }
}

extension Bounds {
    var proposedSize: ProposedSize {
        ProposedSize(size)
    }
}

//
// Created by Mike on 8/6/21.
//

struct ProposedSize: Hashable {
    var width: CGFloat?
    var height: CGFloat?
}

extension ProposedSize {
    static var none: ProposedSize {
        .init()
    }
}

extension ProposedSize {
    init(_ cgSize: CGSize) {
        self.init(width: cgSize.width, height: cgSize.height)
    }
}

extension ProposedSize {
    var orMax: CGSize {
        CGSize(
            width: width ?? .greatestFiniteMagnitude,
            height: height ?? .greatestFiniteMagnitude
        )
    }
}

extension ProposedSize {
    var orDefault: CGSize {
        CGSize(width: width ?? 10, height: height ?? 10)
    }
}

extension ProposedSize {
    func or(_ size: CGSize?) -> CGSize {
        CGSize(
            width: width ?? size?.width ?? 10,
            height: height ?? size?.height ?? 10
        )
    }
}

extension ProposedSize {
    var flipped: ProposedSize {
        ProposedSize(
            width: height,
            height: width
        )
    }
}

extension ProposedSize {
    func inset(by insets: EdgeInsets) -> ProposedSize {
        var copy = self
        if let width = copy.width {
            copy.width = max(width - CGFloat(insets.leading + insets.trailing), 0)
        }
        if let height = copy.height {
            copy.height = max(height - CGFloat(insets.top + insets.bottom), 0)
        }
        return copy
    }
}

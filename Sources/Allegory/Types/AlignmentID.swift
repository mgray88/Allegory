//
// Created by Mike on 7/31/21.
//

/// Types used to identify alignment guides.
///
/// Types conforming to `AlignmentID` have a corresponding alignment guide
/// value, typically declared as a static constant property of
/// ``HorizontalAlignment`` or ``VerticalAlignment``.
public protocol AlignmentID {
    /// The value of the corresponding guide in the given context when not
    /// otherwise set in that context.
    static func defaultValue(in context: ViewDimensions) -> CGFloat
}

internal enum HLeadingAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        0
    }
}
internal enum HCenterAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.width / 2
    }
}
internal enum HTrailingAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.width
    }
}

internal enum VTopAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        0
    }
}
internal enum VCenterAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.height / 2
    }
}
internal enum VBottomAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context.height
    }
}
internal enum VFirstTextBaselineAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        notSupported()
    }
}
internal enum VLastTextBaselineAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        notSupported()
    }
}

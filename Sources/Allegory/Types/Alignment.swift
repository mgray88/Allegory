//
// Created by Mike on 7/31/21.
//

/// An alignment position along the horizontal axis.
public struct HorizontalAlignment: Equatable {
    internal let alignmentID: AlignmentID.Type

    /// Creates an instance with the given identifier.
    ///
    /// Each instance needs a unique identifier.
    ///
    /// > Warning: Custom alignments not currently supported.
    ///
    /// - Parameter id: An identifier that uniquely identifies the horizontal
    ///   alignment.
    public init(_ id: AlignmentID.Type) {
        self.alignmentID = id
    }

    public static func == (lhs: HorizontalAlignment, rhs: HorizontalAlignment) -> Bool {
        lhs.alignmentID == rhs.alignmentID
    }
}

extension HorizontalAlignment {
    /// A guide marking the leading edge of the view.
    public static let leading = HorizontalAlignment(HLeadingAlignment.self)

    /// A guide marking the horizontal center of the view.
    public static let center = HorizontalAlignment(HCenterAlignment.self)

    /// A guide marking the trailing edge of the view.
    public static let trailing = HorizontalAlignment(HTrailingAlignment.self)
}

/// An alignment position along the vertical axis.
public struct VerticalAlignment: Equatable {
    internal let alignmentID: AlignmentID.Type

    /// Creates an instance with the given identifier.
    ///
    /// Each instance needs a unique identifier.
    ///
    /// > Warning: Custom alignments not currently supported.
    ///
    /// - Parameter id: An identifier that uniquely identifies the vertical
    ///   alignment.
    public init(_ id: AlignmentID.Type) {
        self.alignmentID = id
    }

    public static func == (lhs: VerticalAlignment, rhs: VerticalAlignment) -> Bool {
        lhs.alignmentID == rhs.alignmentID
    }
}

extension VerticalAlignment {
    /// A guide marking the top edge of the view.
    public static let top = VerticalAlignment(VTopAlignment.self)

    /// A guide marking the vertical center of the view.
    public static let center = VerticalAlignment(VCenterAlignment.self)

    /// A guide marking the bottom edge of the view.
    public static let bottom = VerticalAlignment(VBottomAlignment.self)

    /// A guide marking the topmost text baseline view.
    ///
    /// > Warning: Not currently supported.
    public static let firstTextBaseline = VerticalAlignment(VFirstTextBaselineAlignment.self)

    /// A guide marking the bottom-most text baseline in a view.
    ///
    /// > Warning: Not currently supported.
    public static let lastTextBaseline = VerticalAlignment(VLastTextBaselineAlignment.self)
}

/// An alignment in both axes.
///
/// The following table shows the various alignment guides next to each other.
/// |  |  |  |
/// | --- | --- | --- |
/// | topLeading | top | topTrailing |
/// | leading | center | trailing |
/// | bottomLeading | bottom | bottomTrailing |
public struct Alignment: Equatable {

    /// The alignment on the horizontal axis.
    public var horizontal: HorizontalAlignment

    /// The alignment on the vertical axis.
    public var vertical: VerticalAlignment

    /// Creates an instance with the given horizontal and vertical alignments.
    ///
    /// - Parameters:
    ///   - horizontal: The alignment on the horizontal axis.
    ///   - vertical: The alignment on the vertical axis.
    @inlinable
    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /// A guide marking the center of the view.
    public static let center = Alignment(horizontal: .center, vertical: .center)

    /// A guide marking the leading edge of the view.
    public static let leading = Alignment(horizontal: .leading, vertical: .center)

    /// A guide marking the trailing edge of the view.
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)

    /// A guide marking the top edge of the view.
    public static let top = Alignment(horizontal: .center, vertical: .top)

    /// A guide marking the bottom edge of the view.
    public static let bottom = Alignment(horizontal: .center, vertical: .bottom)

    /// A guide marking the top and leading edges of the view.
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)

    /// A guide marking the top and trailing edges of the view.
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)

    /// A guide marking the bottom and leading edges of the view.
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)

    /// A guide marking the bottom and trailing edges of the view.
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
}

extension HorizontalAlignment {

    @inlinable
    public var flipped: VerticalAlignment {
        switch self {
        case .leading:
            return .top

        case .center:
            return .center

        case .trailing:
            return .bottom

        default:
            fatalError()
        }
    }
}

extension Alignment {
    func point(for size: CGSize) -> CGPoint {
        let x = horizontal.alignmentID.defaultValue(in: size)
        let y = vertical.alignmentID.defaultValue(in: size)
        return CGPoint(x: x, y: y)
    }
}

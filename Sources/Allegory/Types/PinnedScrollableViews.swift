//
// Created by Mike on 9/1/21.
//

/// A set of view types that may be pinned to the bounds of a scroll view.
public struct PinnedScrollableViews: OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    /// The header view of each Section will be pinned.
    public static let sectionHeaders: PinnedScrollableViews = .init(rawValue: 1)

    /// The footer view of each Section will be pinned.
    public static let sectionFooters: PinnedScrollableViews = .init(rawValue: 2)

    public typealias ArrayLiteralElement = PinnedScrollableViews
    public typealias Element = PinnedScrollableViews
    public typealias RawValue = UInt32
}

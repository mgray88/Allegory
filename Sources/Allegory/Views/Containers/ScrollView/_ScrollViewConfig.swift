//
// Created by Mike on 8/29/21.
//

import UIKit

public struct _ScrollViewConfig {
    public static let decelerationRateNormal: Double =
        Double(UIScrollView.DecelerationRate.normal.rawValue)

    public static let decelerationRateFast: Double =
        Double(UIScrollView.DecelerationRate.fast.rawValue)

    public enum ContentOffset {
        case initially(CGPoint)
        case binding(Binding<CGPoint>)
    }

    public var contentOffset: _ScrollViewConfig.ContentOffset = .initially(.zero)

    public var contentInsets: EdgeInsets = .init()

    public var decelerationRate: Double = decelerationRateNormal

    public var alwaysBounceVertical: Bool = true

    public var alwaysBounceHorizontal: Bool = true

    // TODO: _ScrollViewGestureProvider
    // public var gestureProvider: _ScrollViewGestureProvider

    // TODO: What does stopDraggingImmediately do?
    // public var stopDraggingImmediately: Bool

    public var isScrollEnabled: Bool = true

    public var showsHorizontalIndicator: Bool = true

    public var showsVerticalIndicator: Bool = true

    public var indicatorInsets: EdgeInsets = .zero

    public init() {}
}

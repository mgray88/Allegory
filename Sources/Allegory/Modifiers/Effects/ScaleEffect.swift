//
// Created by Mike on 8/14/21.
//

import UIKit

extension View {

    /// Scales this view's rendered output by the given vertical and horizontal
    /// size amounts, relative to an anchor point.
    ///
    /// Use `scaleEffect(_:anchor:)` to scale a view by applying a scaling
    /// transform of a specific size, specified by `scale`.
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .resizable()
    ///         .frame(width: 100, height: 100, alignment: .center)
    ///         .foregroundColor(Color.red)
    ///         .scaleEffect(CGSize(x: 0.9, y: 1.3), anchor: .leading)
    ///         .border(Color.gray)
    ///
    /// - Parameters:
    ///   - scale: A <doc://com.apple.documentation/documentation/CoreGraphics/CGSize> that
    ///     represents the horizontal and vertical amount to scale the view.
    ///   - anchor: The point with a default of ``UnitPoint/center`` that
    ///     defines the location within the view from which to apply the
    ///     transformation.
    @inlinable
    public func scaleEffect(
        _ scale: CGSize,
        anchor: UnitPoint = .center
    ) -> ModifiedContent<Self, _ScaleEffect> {
        modifier(_ScaleEffect(scale: scale, anchor: anchor))
    }

    /// Scales this view's rendered output by the given amount in both the
    /// horizontal and vertical directions, relative to an anchor point.
    ///
    /// Use `scaleEffect(_:anchor:)` to apply a horizontally and vertically
    /// scaling transform to a view.
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .resizable()
    ///         .frame(width: 100, height: 100, alignment: .center)
    ///         .foregroundColor(Color.red)
    ///         .scaleEffect(2, anchor: .leading)
    ///         .border(Color.gray)
    ///
    /// - Parameters:
    ///   - s: The amount to scale the view in the view in both the horizontal
    ///     and vertical directions.
    ///   - anchor: The anchor point with a default of ``UnitPoint/center`` that
    ///     indicates the starting position for the scale operation.
    @inlinable
    public func scaleEffect(
        _ s: CGFloat,
        anchor: UnitPoint = .center
    ) -> ModifiedContent<Self, _ScaleEffect> {
        scaleEffect(CGSize(width: s, height: s), anchor: anchor)
    }

    /// Scales this view's rendered output by the given horizontal and vertical
    /// amounts, relative to an anchor point.
    ///
    /// Use `scaleEffect(x:y:anchor:)` to apply a scaling transform to a view by
    /// a specific horizontal and vertical amount.
    ///
    ///     Image(systemName: "envelope.badge.fill")
    ///         .resizable()
    ///         .frame(width: 100, height: 100, alignment: .center)
    ///         .foregroundColor(Color.red)
    ///         .scaleEffect(x: 0.5, y: 0.5, anchor: .bottomTrailing)
    ///         .border(Color.gray)
    ///
    /// - Parameters:
    ///   - x: An amount that represents the horizontal amount to scale the
    ///     view. The default value is `1.0`.
    ///   - y: An amount that represents the vertical amount to scale the view.
    ///     The default value is `1.0`.
    ///   - anchor: The anchor point that indicates the starting position for
    ///     the scale operation.
    @inlinable
    public func scaleEffect(
        x: CGFloat = 1.0,
        y: CGFloat = 1.0,
        anchor: UnitPoint = .center
    ) -> ModifiedContent<Self, _ScaleEffect> {
        scaleEffect(CGSize(width: x, height: y), anchor: anchor)
    }
}

public struct _ScaleEffect: GeometryEffect, Equatable {
    public var scale: CGSize
    public var anchor: UnitPoint

    @inlinable
    public init(scale: CGSize, anchor: UnitPoint = .center) {
        self.scale = scale
        self.anchor = anchor
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        .init(.init(scaleX: scale.width, y: scale.height))
    }

    public var animatableData: AnimatablePair<CGSize.AnimatableData, UnitPoint.AnimatableData> {
        get {
            .init(scale.animatableData, anchor.animatableData)
        }
        set {
            (scale.animatableData, anchor.animatableData) = newValue[]
        }
    }
}

extension _ScaleEffect: _PrimitiveViewModifier {
    func modify(view: UIView) {

    }
}

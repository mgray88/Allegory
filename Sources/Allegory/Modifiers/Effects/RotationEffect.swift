//
// Created by Mike on 8/14/21.
//

public struct _RotationEffect: GeometryEffect {
    public var angle: Angle
    public var anchor: UnitPoint

    public init(angle: Angle, anchor: UnitPoint = .center) {
        self.angle = angle
        self.anchor = anchor
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        .init(CGAffineTransform.identity.rotated(by: CGFloat(angle.radians)))
    }

    public func body(content: Content) -> SomeView {
        content
    }

    public var animatableData: AnimatablePair<Angle.AnimatableData, UnitPoint.AnimatableData> {
        get {
            .init(angle.animatableData, anchor.animatableData)
        }
        set {
            (angle.animatableData, anchor.animatableData) = newValue[]
        }
    }
}

extension View {

    /// Rotates this view's rendered output around the specified point.
    ///
    /// Use `rotationEffect(_:anchor:)` to rotate the view by a specific amount.
    ///
    /// In the example below, the text is rotated by 22˚.
    ///
    ///     Text("Rotation by passing an angle in degrees")
    ///         .rotationEffect(.degrees(22))
    ///         .border(Color.gray)
    ///
    /// - Parameters:
    ///   - angle: The angle at which to rotate the view.
    ///   - anchor: The location with a default of ``UnitPoint/center`` that
    ///     defines a point at which the rotation is anchored.
    public func rotationEffect(
        _ angle: Angle,
        anchor: UnitPoint = .center
    ) -> ModifiedContent<Self, _RotationEffect> {
        modifier(_RotationEffect(angle: angle, anchor: anchor))
    }
}

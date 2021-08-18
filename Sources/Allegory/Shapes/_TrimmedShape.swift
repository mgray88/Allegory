//
// Created by Mike on 8/17/21.
//

public struct _TrimmedShape<S>: Shape where S: Shape {
    public var shape: S
    public var startFraction: CGFloat
    public var endFraction: CGFloat

    @inlinable
    public init(shape: S, startFraction: CGFloat = 0, endFraction: CGFloat = 1) {
        self.shape = shape
        self.startFraction = startFraction
        self.endFraction = endFraction
    }

    public func path(in rect: CGRect) -> Path {
        shape
            .path(in: rect)
            .trimmedPath(from: startFraction, to: endFraction)
    }

    public typealias AnimatableData = AnimatablePair<
        S.AnimatableData,
        AnimatablePair<CGFloat, CGFloat>
    >
    public var animatableData: AnimatableData {
        get {
            .init(shape.animatableData, .init(startFraction, endFraction))
        }
        set {
            shape.animatableData = newValue[].0
            (startFraction, endFraction) = newValue[].1[]
        }
    }

    public typealias Body = _ShapeView<_TrimmedShape<S>, ForegroundStyle>
}

extension Shape {
    @inlinable
    public func trim(
        from startFraction: CGFloat = 0,
        to endFraction: CGFloat = 1
    ) -> _TrimmedShape<Self> {
        _TrimmedShape(
            shape: self,
            startFraction: startFraction,
            endFraction: endFraction
        )
    }

}

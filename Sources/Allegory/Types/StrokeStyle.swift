//
// Created by Mike on 7/30/21.
//

/// The characteristics of a stroke that traces a path.
public struct StrokeStyle : Equatable {

    /// The width of the stroked path.
    public var lineWidth: CGFloat

    /// The endpoint style of a line.
    public var lineCap: CGLineCap

    /// The join type of a line.
    public var lineJoin: CGLineJoin

    /// A threshold used to determine whether to use a bevel instead of a
    /// miter at a join.
    public var miterLimit: CGFloat

    /// The lengths of painted and unpainted segments used to make a dashed line.
    public var dash: [CGFloat]

    /// How far into the dash pattern the line starts.
    public var dashPhase: CGFloat

    /// Creates a new stroke style from the given components.
    ///
    /// - Parameters:
    ///   - lineWidth: The width of the segment.
    ///   - lineCap: The endpoint style of a segment.
    ///   - lineJoin: The join type of a segment.
    ///   - miterLimit: The threshold used to determine whether to use a bevel
    ///     instead of a miter at a join.
    ///   - dash: The lengths of painted and unpainted segments used to make a
    ///     dashed line.
    ///   - dashPhase: How far into the dash pattern the line starts.
    public init(
        lineWidth: CGFloat = 1,
        lineCap: CGLineCap = .butt,
        lineJoin: CGLineJoin = .miter,
        miterLimit: CGFloat = 10,
        dash: [CGFloat] = [CGFloat](),
        dashPhase: CGFloat = 0
    ) {
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
}

extension StrokeStyle: Animatable {
    public typealias AnimatableData = AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>>
    public var animatableData: StrokeStyle.AnimatableData {
        get {
            TODO()
        }
        set {
            TODO()
        }
    }
}

extension StrokeStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        layer.lineDashPhase = dashPhase
        layer.lineDashPattern = dash.map {
            NSNumber(value: Double($0))
        }

        switch lineCap {
        case .butt:
            layer.lineCap = .butt

        case .round:
            layer.lineCap = .round

        case .square:
            layer.lineCap = .square

        @unknown default:
            break
        }

        switch lineJoin {
        case .miter:
            layer.lineJoin = .miter

        case .round:
            layer.lineJoin = .round

        case .bevel:
            layer.lineJoin = .bevel

        @unknown default:
            break
        }
    }
}

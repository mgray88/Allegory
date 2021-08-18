//
// Created by Mike on 7/31/21.
//

public protocol ShapeStyle {
    func _apply(to shape: inout _ShapeStyle_Shape)
    static func _apply(to type: inout _ShapeStyle_ShapeType)
}

extension ShapeStyle {
    public func _apply(to shape: inout _ShapeStyle_Shape) {}
    public static func _apply(to type: inout _ShapeStyle_ShapeType) {}
}

extension ShapeStyle {
    public func `in`(_ rect: CGRect) -> ShapeStyle {
        _AnchoredShapeStyle(style: self, bounds: rect)
    }
}

/// Default View.body implementation to fill a Rectangle with `self`.
extension ShapeStyle where Self: View, Self.Body == _ShapeView<Rectangle, Self> {

    public var body: _ShapeView<Rectangle, Self> {
        _ShapeView(shape: Rectangle(), style: self)
    }
}

public struct _ShapeStyle_Shape {
    public let operation: Operation
    public var result: Result
    public var environment: EnvironmentValues
    public var bounds: CGRect?
    public var role: ShapeRole
    public var inRecursiveStyle: Bool

    public init(
        for operation: Operation,
        in environment: EnvironmentValues,
        role: ShapeRole
    ) {
        self.operation = operation
        result = .none
        self.environment = environment
        bounds = nil
        self.role = role
        inRecursiveStyle = false
    }

    public enum Operation {
        case prepare(Text, level: Int)
        case resolveStyle(levels: Range<Int>)
        case fallbackColor(level: Int)
        case multiLevel
        case copyForeground
        case primaryStyle
        case modifyBackground
    }

    public enum Result {
        case prepared(Text)
        case resolved(_ResolvedStyle)
        case style(AnyShapeStyle)
        case color(Color)
        case bool(Bool)
        case none

        public func resolvedStyle(
            on shape: _ShapeStyle_Shape,
            in environment: EnvironmentValues
        ) -> _ResolvedStyle? {
            switch self {
            case let .resolved(resolved): return resolved
            case let .style(anyStyle):
                var copy = shape
                anyStyle._apply(to: &copy)
                return copy.result.resolvedStyle(on: shape, in: environment)
            case let .color(color):
                return .color(color.provider.resolve(in: environment))
            default:
                return nil
            }
        }
    }
}

public struct _ShapeStyle_ShapeType {}

public indirect enum _ResolvedStyle {
    case color(AnyColorBox.ResolvedValue)
//    case paint(AnyResolvedPaint) // I think is used for Image as a ShapeStyle (SwiftUI.ImagePaint).
//    case foregroundMaterial(AnyColorBox.ResolvedValue, _MaterialStyle)
//    case backgroundMaterial(AnyColorBox.ResolvedValue)
    case array([_ResolvedStyle])
    case opacity(Float, _ResolvedStyle)
//    case multicolor(ResolvedMulticolorStyle)

    public func color(at level: Int) -> Color? {
        switch self {
        case let .color(resolved):
            return Color(_ConcreteColorBox(resolved))
//        case let .foregroundMaterial(resolved, _):
//            return Color(_ConcreteColorBox(resolved))
        case let .array(children):
            return children[level].color(at: level)
        case let .opacity(opacity, resolved):
            guard let color = resolved.color(at: level) else { return nil }
            return color.opacity(Double(opacity))
        }
    }
}

extension ShapeStyle {
    func resolve(
        for operation: _ShapeStyle_Shape.Operation,
        in environment: EnvironmentValues,
        role: ShapeRole
    ) -> _ResolvedStyle? {
        var shape = _ShapeStyle_Shape(
            for: operation,
            in: environment,
            role: role
        )
        _apply(to: &shape)
        return shape.result
            .resolvedStyle(on: shape, in: environment)
    }
}

//
// Created by Mike on 7/27/21.
//

/// The outline of a 2D shape.
public struct Path: Equatable {
    @usableFromInline
    final internal class PathBox: Equatable {
        internal var elements: [Element] = []

        @usableFromInline
        internal static func == (lhs: Path.PathBox, rhs: Path.PathBox) -> Bool {
            lhs.elements == rhs.elements
        }

        internal init() {}

        internal init(elements: [Element]) {
            self.elements = elements
        }
    }

    @usableFromInline
    internal enum Storage: Equatable {
        case empty
        case rect(CGRect)
        case ellipse(CGRect)
        indirect case roundedRect(FixedRoundedRect)
        indirect case stroked(StrokedPath)
        indirect case trimmed(TrimmedPath)
        case path(Path.PathBox)

        @usableFromInline
        internal static func == (a: Path.Storage, b: Path.Storage) -> Bool {
            switch (a, b) {
            case (.empty, .empty):
                return true

            case let (.rect(lRect), .rect(rRect)):
                return lRect == rRect

            case let (.ellipse(lEllipse), .ellipse(rEllipse)):
                return lEllipse == rEllipse

            case let (.roundedRect(lRect), .roundedRect(rRect)):
                return lRect == rRect

            case let (.stroked(lStroke), .stroked(rStroke)):
                return lStroke == rStroke

            case let (.trimmed(lTrimmed), .trimmed(rTrimmed)):
                return lTrimmed == rTrimmed

            case let (.path(lPath), .path(rPath)):
                return lPath == rPath

            default:
                return false
            }
        }
    }

    internal var storage: Path.Storage
    internal var elements: [Element] { storage.elements }

    @usableFromInline
    internal init(storage: Path.Storage) {
        self.storage = storage
    }

    public init() {
        self.storage = .empty
    }

    public init(_ path: CGPath) {
        self.storage = .path(
            .init(elements: path.elements.map { $0.pathElement })
        )
    }

    public init(_ path: CGMutablePath) {
        self.init(path as CGPath)
    }

    public init(_ rect: CGRect) {
        self.storage = .rect(rect)
    }

    public init(
        roundedRect rect: CGRect,
        cornerRadius: CGFloat,
        style: RoundedCornerStyle = .circular
    ) {
        self.storage = .roundedRect(
            .init(
                rect: rect,
                cornerSize: .init(width: cornerRadius, height: cornerRadius),
                style: style
            )
        )
    }

    public init(
        roundedRect rect: CGRect,
        cornerSize: CGSize,
        style: RoundedCornerStyle = .circular
    ) {
        self.storage = .roundedRect(
            .init(
                rect: rect,
                cornerSize: cornerSize,
                style: style
            )
        )
    }

    public init(ellipseIn rect: CGRect) {
        self.storage = .ellipse(rect)
    }

    public init(_ callback: (inout Path) -> ()) {
        var path = Path()
        callback(&path)
        self = path
    }

    public var description: String {
        ""
    }

    public var cgPath: CGPath {
        guard storage != .empty else { return CGMutablePath() }
        let path = CGMutablePath()
        for element in elements {
            switch element {
            case .move(let p):
                path.move(to: p)
            case .line(let p):
                path.addLine(to: p)
            case .quadCurve(let p, let cp):
                path.addQuadCurve(to: p, control: cp)
            case .curve(let p, let cp1, let cp2):
                path.addCurve(to: p, control1: cp1, control2: cp2)
            case .closeSubpath:
                path.closeSubpath()
            }
        }
        return path
    }

    public var isEmpty: Bool {
        storage == .empty
    }

    public var boundingRect: CGRect {
        cgPath.boundingBoxOfPath
    }

    public enum Element: Equatable {
        case closeSubpath
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case line(to: CGPoint)
        case move(to: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)

        public var description: String {
            switch self {
            case .move(to: let to):
                return "moveto \(to)"
            case .line(to: let to):
                return "lineto \(to)"
            case .quadCurve(let to, let control):
                return "quadcureveto \(to) \(control)"
            case .curve(let to, let control1, let control2):
                return "cureveto \(to) \(control1) \(control2)"
            case .closeSubpath:
                return "closepath"
            }
        }

        var points: [CGPoint] {
            switch self {
            case .move(to: let to):
                return [to]
            case .line(to: let to):
                return [to]
            case .quadCurve(let to, let control):
                return [to, control]
            case .curve(let to, let control1, let control2):
                return [to, control1, control2]
            case .closeSubpath:
                return []
            }
        }

        func mapPoints(_ transform: (CGPoint) -> CGPoint) -> Element {
            switch self {
            case .move(to: let to):
                return .move(to: transform(to))
            case .line(to: let to):
                return .line(to: transform(to))
            case .quadCurve(let to, let control):
                return .quadCurve(to: transform(to), control: transform(control))
            case .curve(let to, let control1, let control2):
                return .curve(to: transform(to), control1: transform(control1), control2: transform(control2))
            case .closeSubpath:
                return .closeSubpath
            }
        }
    }

    public func contains(_ p: CGPoint, eoFill: Bool = false) -> Bool {
        false // TODO
    }

    public func forEach(_ body: (Path.Element) -> Void) {
        elements.forEach(body)
    }

    public func strokedPath(_ style: StrokeStyle) -> Path {
        var path = self
        path.storage = .stroked(.init(path: self, style: style))
        return path
    }

    public func trimmedPath(from: CGFloat, to: CGFloat) -> Path {
        var path = self
        path.storage = .trimmed(.init(path: self, from: from, to: to))
        return path
    }
}

extension Path: Shape {
    public static var role: ShapeRole { .stroke }

    public func path(in rect: CGRect) -> Path {
        self
    }
}

private extension CGPathElement {
    var pathElement: Path.Element {
        switch type {
        case .moveToPoint:
            return .move(to: points[0])
        case .addLineToPoint:
            return .line(to: points[0])
        case .addQuadCurveToPoint:
            return .quadCurve(to: points[0], control: points[1])
        case .addCurveToPoint:
            return .curve(to: points[0], control1: points[1], control2: points[2])
        case .closeSubpath:
            return .closeSubpath
        @unknown default:
            fatalError()
        }
    }
}

private extension CGPath {
    var elements: [CGPathElement] {
        var elements: [CGPathElement] = []
        forEach {
            elements.append($0)
        }
        return elements
    }

    private func forEach( body: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
}

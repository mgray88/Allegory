//
// Created by Mike on 7/30/21.
//

public protocol ShapeModifier: SomeShapeModifier {
    associatedtype Body: Shape
    typealias Content = ShapeModifierContent<Self>
    func body(content: Content) -> Body
}

extension ShapeModifier {
    public func body(content: SomeShape) -> SomeShape {
        (body(content: Content(content, modifier: self)) as Body) as SomeShape
    }
}

extension ShapeModifier where Body == Never {
    public func body(content: Content) -> Never {
        fatalError()
    }
}

public struct ShapeModifierContent<SM: SomeShapeModifier>: Shape {
    public typealias Body = Never

    public let shape: SomeShape
    public let modifier: SM

    public init(_ shape: SomeShape, modifier: SM) {
        self.shape = shape
        self.modifier = modifier
    }

    public func path(in _: CGRect) -> Path {
        fatalError()
    }
}

extension Shape {
    public func modifier<Modifier: ShapeModifier>(
        _ modifier: Modifier
    ) -> ModifiedShapeContent<Self, Modifier> {
        ModifiedShapeContent(content: self, modifier: modifier)
    }
}

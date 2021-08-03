//
// Created by Mike on 7/30/21.
//

public struct ModifiedShapeContent<Content, Modifier>: Shape
    where Content: Shape, Modifier: ShapeModifier {

    public let content: Content
    public let modifier: Modifier

    @inlinable
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }

    public func path(in rect: CGRect) -> Path {
        content.path(in: rect)
    }
}

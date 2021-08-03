//
// Created by Mike on 7/31/21.
//

/// A shape with a translation offset transform applied to it.
public struct OffsetShape<Content>: Shape where Content : Shape {

    public var shape: Content

    public var offset: CGSize

    @inlinable
    public init(shape: Content, offset: CGSize) {
        self.shape = shape
        self.offset = offset
    }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    ///
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path {
        shape.path(in: rect).offsetBy(dx: offset.width, dy: offset.height)
    }

    public var body: Body {
        _ShapeView(shape: self, style: ForegroundStyle())
    }

    public typealias Body = _ShapeView<Self, ForegroundStyle>
}

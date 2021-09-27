//
// Created by Mike on 9/25/21.
//

extension View {
    /// TODO
    public func contentShape<S>(
        _ shape: S,
        eoFill: Bool = false
    ) -> ModifiedContent<Self, _ContentShapeModifier<S>> where S: Shape {
        modifier(_ContentShapeModifier(shape: shape, eoFill: eoFill))
    }
}

public struct _ContentShapeModifier<ContentShape>: ViewModifier
    where ContentShape: Shape {

    public var shape: ContentShape
    public var eoFill: Bool

    @inlinable
    public init(shape: ContentShape, eoFill: Bool = false) {
        self.shape = shape
        self.eoFill = eoFill
    }
}

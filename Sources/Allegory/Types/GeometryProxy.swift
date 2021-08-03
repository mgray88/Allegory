//
// Created by Mike on 7/31/21.
//

/// A proxy for access to the size and coordinate space (for anchor resolution)
/// of the container view.
public struct GeometryProxy {
    /// The size of the container view.
    public let size: CGSize

    /// The safe area inset of the container view.
    public let safeAreaInsets: EdgeInsets

    private let getFrame: (CoordinateSpace) -> CGRect

    internal init(
        size: CGSize,
        safeAreaInsets: EdgeInsets,
        getFrame: @escaping (CoordinateSpace) -> CGRect
    ) {
        self.size = size
        self.safeAreaInsets = safeAreaInsets
        self.getFrame = getFrame
    }

    /// Returns the container view’s bounds rectangle, converted to a defined
    /// coordinate space.
    public func frame(in coordinateSpace: CoordinateSpace) -> CGRect {
        getFrame(coordinateSpace)
    }
}

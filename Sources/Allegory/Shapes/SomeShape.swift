//
// Created by Mike on 7/30/21.
//

public protocol SomeShape: SomeView {
    /// An indication of how to style a shape.
    static var role: ShapeRole { get }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    /// - Returns: A path that describes this shape.
    func path(in rect: CGRect) -> Path
}

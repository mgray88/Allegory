//
// Created by Mike on 8/1/21.
//

extension View {
    /// Adds a border to this view with the specified style and width.
    ///
    /// - Parameters:
    ///   - content: The border style.
    ///   - width: The thickness of the border; if not provided, the default is
    ///     1 pixel.
    /// - Returns: A view that adds a border with the specified style and width
    ///   to this view.
    @inlinable
    public func border<S: ShapeStyle>(
        _ content: S,
        width: CGFloat = 1
    ) -> ModifiedContent<Self, ViewModifiers._Overlay<_ShapeView<_StrokedShape<Rectangle._Inset>, S>>> {
        overlay {
            Rectangle()
                .inset(by: width / 2)
                .stroke(content, lineWidth: width)
        }
    }
}

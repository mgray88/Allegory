//
// Created by Mike on 8/1/21.
//

public struct _InsetShape<Content: Shape>: Shape, View {

    private let inset: CGFloat
    private let content: Content

    internal init(inset: CGFloat, content: Content) {
        self.inset = inset
        self.content = content
    }

    public func path(in rect: CGRect) -> Path {
        content.path(in: rect.insetBy(dx: inset, dy: inset))
    }
}

extension Shape {
    public func insetBy(by amount: CGFloat) -> _InsetShape<Self> {
        _InsetShape(inset: amount, content: self)
    }
}

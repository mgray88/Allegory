//
// Created by Mike on 8/17/21.
//

@usableFromInline
internal struct FixedRoundedRect: Equatable {
    internal let rect: CGRect
    internal let cornerSize: CGSize?
    internal let style: RoundedCornerStyle

    @usableFromInline
    internal init(rect: CGRect, cornerSize: CGSize, style: RoundedCornerStyle) {
        (self.rect, self.cornerSize, self.style) = (rect, cornerSize, style)
    }

    @usableFromInline
    internal init(capsule rect: CGRect, style: RoundedCornerStyle) {
        (self.rect, cornerSize, self.style) = (rect, nil, style)
    }
}

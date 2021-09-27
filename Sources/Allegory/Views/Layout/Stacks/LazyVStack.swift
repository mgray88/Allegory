//
// Created by Mike on 9/1/21.
//

struct LazyVStack<Content>: View where Content: View {
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) {}

}

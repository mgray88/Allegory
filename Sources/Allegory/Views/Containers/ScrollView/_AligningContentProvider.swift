//
// Created by Mike on 8/29/21.
//

public struct _AligningContentProvider<Content>: _ScrollableContentProvider where Content: View {
    public var content: Content
    public var horizontal: TextAlignment?
    public var vertical: _VAlignment?

    public init(
        content: Content,
        horizontal: TextAlignment? = nil,
        vertical: _VAlignment? = nil
    ) {
        self.content = content
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public var scrollableContent: ModifiedContent<
    Content,
    _AligningContentProvider<Content>.AligningContentProviderLayout
    > {
        content.modifier(.init()) // TODO
    }

    public struct AligningContentProviderLayout {
        public typealias AnimatableData = EmptyAnimatableData
        public typealias Body = Never
    }

    public typealias Root = _ScrollViewRoot<_AligningContentProvider<Content>>

    public typealias ScrollableContent = ModifiedContent<
    Content,
    _AligningContentProvider<Content>.AligningContentProviderLayout
    >
}

extension _AligningContentProvider.AligningContentProviderLayout: ViewModifier {}
extension _AligningContentProvider.AligningContentProviderLayout: Animatable {}

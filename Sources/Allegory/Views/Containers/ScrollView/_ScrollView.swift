//
// Created by Mike on 8/29/21.
//

public struct _ScrollView<Provider>: View where Provider: _ScrollableContentProvider {
    public var contentProvider: Provider
    public var config: _ScrollViewConfig

    public init(
        contentProvider: Provider,
        config: _ScrollViewConfig = _ScrollViewConfig()
    ) {
        self.contentProvider = contentProvider
        self.config = config
    }

    public var body: Provider.Root {
        contentProvider.root(scrollView: Main())
    }

    public struct Main: View {
        public typealias Body = Swift.Never
    }
}

extension View {
    public func _scrollable(
        stretchChildrenToMaxHeight: Bool = false,
        horizontal: TextAlignment? = .center,
        vertical: _VAlignment? = .center
    ) -> _ScrollView<_AligningContentProvider<Self>> {
        .init(
            contentProvider: .init(
                content: self,
                horizontal: horizontal,
                vertical: vertical
            )
        )
    }
}

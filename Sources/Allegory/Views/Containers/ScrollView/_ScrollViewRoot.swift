//
// Created by Mike on 8/29/21.
//

public struct _ScrollViewRoot<P>: View where P: _ScrollableContentProvider {

    private let provider: P

    init(_ provider: P) {
        self.provider = provider
    }

    public var body: P.ScrollableContent {
        provider.scrollableContent
    }

    public typealias Body = P.ScrollableContent
}

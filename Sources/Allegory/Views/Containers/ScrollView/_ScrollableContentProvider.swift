//
// Created by Mike on 8/29/21.
//

public protocol _ScrollableContentProvider {
    associatedtype ScrollableContent : View
    var scrollableContent: Self.ScrollableContent { get }
    associatedtype Root : View
    func root(scrollView: _ScrollView<Self>.Main) -> Self.Root
    func decelerationTarget(
        contentOffset: CGPoint,
        originalContentOffset: CGPoint,
        velocity: _Velocity<CGSize>,
        size: CGSize
    ) -> CGPoint?
}

extension _ScrollableContentProvider {
    public func decelerationTarget(
        contentOffset: CGPoint,
        originalContentOffset: CGPoint,
        velocity: _Velocity<CGSize>,
        size: CGSize
    ) -> CGPoint? {
        nil
    }
}

extension _ScrollableContentProvider {
    public func root(
        scrollView: _ScrollView<Self>.Main
    ) -> _ScrollViewRoot<Self> {
        .init(self)
    }
}

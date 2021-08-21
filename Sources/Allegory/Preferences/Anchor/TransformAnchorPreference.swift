//
// Created by Mike on 8/19/21.
//

extension View {
    @inlinable
    public func transformAnchorPreference<A, K>(
        key _: K.Type = K.self,
        value: Anchor<A>.Source,
        transform: @escaping (inout K.Value, Anchor<A>) -> Void
    ) -> ModifiedContent<Self, _AnchorTransformModifier<A, K>> where K: PreferenceKey {
        modifier(_AnchorTransformModifier<A, K>(
            anchor: value, transform: transform))
    }

}

public struct _AnchorTransformModifier<AnchorValue, Key>: ViewModifier
    where Key: PreferenceKey {

    public var anchor: Anchor<AnchorValue>.Source
    public var transform: (inout Key.Value, Anchor<AnchorValue>) -> Void

    @inlinable
    public init(
        anchor: Anchor<AnchorValue>.Source,
        transform: @escaping (inout Key.Value, Anchor<AnchorValue>) -> Void
    ) {
        self.anchor = anchor
        self.transform = transform
    }

    public typealias Body = Never
}

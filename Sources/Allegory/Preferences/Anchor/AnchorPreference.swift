//
// Created by Mike on 8/19/21.
//

extension View {
    @inlinable
    public func anchorPreference<A, K>(
        key _: K.Type = K.self,
        value: Anchor<A>.Source,
        transform: @escaping (Anchor<A>) -> K.Value
    ) -> ModifiedContent<Self, _AnchorWritingModifier<A, K>> where K: PreferenceKey {
        modifier(_AnchorWritingModifier<A, K>(
            anchor: value, transform: transform))
    }
}

public struct _AnchorWritingModifier<AnchorValue, Key>: ViewModifier
    where Key: PreferenceKey {

    public var anchor: Anchor<AnchorValue>.Source
    public var transform: (Anchor<AnchorValue>) -> Key.Value

    @inlinable
    public init(
        anchor: Anchor<AnchorValue>.Source,
        transform: @escaping (Anchor<AnchorValue>) -> Key.Value
    ) {
        self.anchor = anchor
        self.transform = transform
    }

    public typealias Body = Never
}

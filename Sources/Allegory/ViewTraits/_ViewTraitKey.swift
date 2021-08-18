//
// Created by Mike on 8/14/21.
//

public protocol _ViewTraitKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

public protocol _TraitWritingModifierProtocol {
    func modifyViewTraitStore(_ viewTraitStore: inout _ViewTraitStore)
}

public struct _TraitWritingModifier<Trait>: ViewModifier, _TraitWritingModifierProtocol
    where Trait: _ViewTraitKey
{
    public typealias Body = Never

    public let value: Trait.Value

    @inlinable
    public init(value: Trait.Value) {
        self.value = value
    }

    public func modifyViewTraitStore(_ viewTraitStore: inout _ViewTraitStore) {
        viewTraitStore.insert(value, forKey: Trait.self)
    }
}

extension ModifiedContent: _TraitWritingModifierProtocol
    where Modifier: _TraitWritingModifierProtocol {

    public func modifyViewTraitStore(_ viewTraitStore: inout _ViewTraitStore) {
        modifier.modifyViewTraitStore(&viewTraitStore)
    }
}

extension View {
    @inlinable
    public func _trait<K>(
        _ key: K.Type,
        _ value: K.Value
    ) -> ModifiedContent<Self, _TraitWritingModifier<K>> where K: _ViewTraitKey {
        modifier(_TraitWritingModifier<K>(value: value))
    }
}


//
// Created by Mike on 8/24/21.
//

extension View {

    /// Sets the unique tag value of this view.
    ///
    /// Use `tag(_:)` to differentiate between a number of views for the purpose
    /// of selecting controls like pickers and lists. Tag values can be of any
    /// type that conforms to the <doc://com.apple.documentation/documentation/Swift/Hashable>
    /// protocol.
    ///
    /// In the example below, the ``ForEach`` loop in the ``Picker`` view
    /// builder iterates over the `Flavor` enumeration. It extracts the text raw
    /// value of each enumeration element for use as the row item label and uses
    /// the enumeration item itself as input to the `tag(_:)` modifier.
    /// The tag identifier can be any value that conforms to the
    /// <doc://com.apple.documentation/documentation/Swift/Hashable> protocol:
    ///
    ///     struct FlavorPicker: View {
    ///         enum Flavor: String, CaseIterable, Identifiable {
    ///             var id: String { self.rawValue }
    ///             case vanilla, chocolate, strawberry
    ///         }
    ///
    ///         @State private var selectedFlavor: Flavor? = nil
    ///         var body: some View {
    ///             Picker("Flavor", selection: $selectedFlavor) {
    ///                 ForEach(Flavor.allCases) {
    ///                     Text($0.rawValue).tag($0)
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - SeeAlso: `List`, `Picker`, `Hashable`
    /// - Parameter tag: A <doc://com.apple.documentation/documentation/Swift/Hashable> value
    ///   to use as the view's tag.
    ///
    /// - Returns: A view with the specified tag set.
    @inlinable
    public func tag<V>(
        _ tag: V
    ) -> ModifiedContent<Self, _TraitWritingModifier<_TagValueTraitKey<V>>> where V: Hashable {
        _trait(_TagValueTraitKey<V>.self, .tagged(tag))
    }

    @inlinable
    public func _untagged(
    ) -> ModifiedContent<Self, _TraitWritingModifier<IsAuxiliaryContentTraitKey>> {
        _trait(IsAuxiliaryContentTraitKey.self, true)
    }

}

public struct _TagValueTraitKey<V>: _ViewTraitKey where V: Hashable {
    public enum Value {
        case untagged
        case tagged(V)
    }

    @inlinable
    public static var defaultValue: _TagValueTraitKey<V>.Value {
        get { .untagged }
    }
}

public struct IsAuxiliaryContentTraitKey: _ViewTraitKey {
    @inlinable
    public static var defaultValue: Bool {
        get { false }
    }

    @usableFromInline
    public typealias Value = Bool
}

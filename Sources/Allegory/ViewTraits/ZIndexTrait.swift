//
// Created by Mike on 8/18/21.
//

extension View {

    /// Controls the display order of overlapping views.
    ///
    /// Use `zIndex(_:)` when you want to control the front-to-back ordering of
    /// views.
    ///
    /// In this example there are two overlapping rotated rectangles. The
    /// frontmost is represented by the larger index value.
    ///
    ///     VStack {
    ///         Rectangle()
    ///             .fill(Color.yellow)
    ///             .frame(width: 100, height: 100, alignment: .center)
    ///             .zIndex(1) // Top layer.
    ///
    ///         Rectangle()
    ///             .fill(Color.red)
    ///             .frame(width: 100, height: 100, alignment: .center)
    ///             .rotationEffect(.degrees(45))
    ///             // Here a zIndex of 0 is the default making
    ///             // this the bottom layer.
    ///     }
    ///
    /// - Parameter value: A relative front-to-back ordering for this view; the
    ///   default is `0`.
    @inlinable
    public func zIndex(
        _ value: Double
    ) -> ModifiedContent<Self, _TraitWritingModifier<_ZIndexTraitKey>> {
        _trait(_ZIndexTraitKey.self, value)
    }
}

public struct _ZIndexTraitKey: _ViewTraitKey {
    @inlinable
    public static var defaultValue: Double {
        get { 0.0 }
    }

    public typealias Value = Double
}

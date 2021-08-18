//
// Created by Mike on 8/14/21.
//

extension View {

    /// Sets the transparency of this view.
    ///
    /// Apply opacity to reveal views that are behind another view or to
    /// de-emphasize a view.
    ///
    /// When applying the `opacity(_:)` modifier to a view that has already had
    /// its opacity transformed, the modifier multiplies the effect of the
    /// underlying opacity transformation.
    ///
    /// The example below shows yellow and red rectangles configured to overlap.
    /// The top yellow rectangle has its opacity set to 50%, allowing the
    /// occluded portion of the bottom rectangle to be visible:
    ///
    ///     struct Opacity: View {
    ///         var body: some View {
    ///             VStack {
    ///                 Color.yellow.frame(width: 100, height: 100, alignment: .center)
    ///                     .zIndex(1)
    ///                     .opacity(0.5)
    ///
    ///                 Color.red.frame(width: 100, height: 100, alignment: .center)
    ///                     .padding(-40)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter opacity: A value between 0 (fully transparent) and 1 (fully
    ///   opaque).
    ///
    /// - Returns: A view that sets the transparency of this view.
    public func opacity(
        _ opacity: Double
    ) -> ModifiedContent<Self, _OpacityEffect> {
        modifier(_OpacityEffect(opacity: opacity))
    }
}

public struct _OpacityEffect: Animatable, ViewModifier, Equatable {
    public var opacity: Double

    public init(opacity: Double) {
        self.opacity = opacity
    }

    public func body(content: Content) -> SomeView {
        content
    }

    public var animatableData: Double {
        get { opacity }
        set { opacity = newValue }
    }
}

//extension _OpacityEffect: UIKitNodeModifierResolvable {
//    private class Node: UIKitNodeModifier {
//        var hierarchyIdentifier: String {
//            "opacity"
//        }
//
//        private var modifier: _OpacityEffect!
//
//        func update(viewModifier: _OpacityEffect, context: inout Context) {
//            modifier = viewModifier
//        }
//    }
//
//    func resolve(
//        context: Context,
//        cachedNodeModifier: AnyUIKitNodeModifier?
//    ) -> AnyUIKitNodeModifier {
//        fatalError("resolve(context:cachedNodeModifier:) has not been implemented")
//    }
//}

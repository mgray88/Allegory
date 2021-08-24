//
// Created by Mike on 8/22/21.
//

extension View {
    /// Adds a shadow to this view.
    ///
    /// The example below a series shows of boxes with increasing degrees of
    /// shadow ranging from 0 (no shadow) to 5 points of shadow, offset down and
    /// to the right of the views:
    ///
    ///     struct Shadow: View {
    ///         var body: some View {
    ///             HStack {
    ///                 ForEach(0..<6) {
    ///                     Color.red.frame(width: 60, height: 60, alignment: .center)
    ///                         .overlay(Text("\($0)"),
    ///                                  alignment: .bottom)
    ///                         .shadow(color: Color.gray,
    ///                                 radius: 1.0,
    ///                                 x: CGFloat($0),
    ///                                 y: CGFloat($0))
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - color: The shadow's color.
    ///   - radius: The shadow's size.
    ///   - x: A horizontal offset you use to position the shadow relative to
    ///     this view.
    ///   - y: A vertical offset you use to position the shadow relative to this
    ///     view.
    ///
    /// - Returns: A view that adds a shadow to this view.
//    @inlinable
//    public func shadow(
//        color: Color = Color(.sRGBLinear, white: 0, opacity: 0.33),
//        radius: CGFloat,
//        x: CGFloat = 0,
//        y: CGFloat = 0
//    ) -> ModifiedContent<Self, _ShadowEffect> {
//        modifier(
//            _ShadowEffect(
//                color: color,
//                radius: radius,
//                offset: CGSize(width: x, height: y)
//            ))
//    }
}

public struct _ShadowEffect: EnvironmentalModifier, Equatable {
    public var color: Color
    public var radius: CGFloat
    public var offset: CGSize

    @inlinable
    public init(color: Color, radius: CGFloat, offset: CGSize) {
        self.color = color
        self.radius = radius
        self.offset = offset
    }

    public func resolve(in environment: EnvironmentValues) -> _ShadowEffect._Resolved {
        TODO()
    }

    public var _requiresMainThread: Bool {
        true
    }

    public struct _Resolved {
        public typealias AnimatableData = AnimatablePair<AnimatablePair<Float, AnimatablePair<Float, AnimatablePair<Float, Float>>>, AnimatablePair<CGFloat, CGSize.AnimatableData>>
        public var animatableData: _ShadowEffect._Resolved.AnimatableData {
            get { TODO() }
            set { TODO() }
        }
        public typealias Body = Never
    }

    public static func == (a: _ShadowEffect, b: _ShadowEffect) -> Bool {
        TODO()
    }

    public typealias Body = Never
    public typealias ResolvedModifier = _ShadowEffect._Resolved
}

extension _ShadowEffect._Resolved: Animatable {}
extension _ShadowEffect._Resolved: ViewModifier {}

//
// Created by Mike on 8/14/21.
//

/// The possible types of color schemes, like Dark Mode.
///
/// The color scheme enumerates the user setting options for Light or Dark Mode.
/// It also provides the light or dark options for any particular view when the
/// app wants to override the user setting.
public enum ColorScheme: CaseIterable, Equatable {
    case dark
    case light
}

public struct _ColorSchemeKey: EnvironmentKey {
    public static let defaultValue: ColorScheme = .light
}

extension EnvironmentValues {
    public var colorScheme: ColorScheme {
        get { self[_ColorSchemeKey.self] }
        set { self[_ColorSchemeKey.self] = newValue }
    }
}

extension View {
    public func colorScheme(
        _ colorScheme: ColorScheme
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<ColorScheme>> {
        environment(\.colorScheme, colorScheme)
    }
}

//public struct PreferredColorSchemeKey: PreferenceKey {
//    public typealias Value = ColorScheme?
//    public static func reduce(value: inout Value, nextValue: () -> Value) {
//        value = nextValue()
//    }
//}

public extension View {

    /// Sets the preferred color scheme for this presentation.
    ///
    /// The color scheme applies to the nearest enclosing presentation, such as
    /// a popover or window. Views may read the color scheme using the
    /// `colorScheme` environment value.
    ///
    /// In the example below the presentation containing the ``VStack`` has its
    /// color scheme set to ``ColorScheme/dark``:
    ///
    ///     VStack {
    ///         Button(action: {}) {
    ///             Text(" Button")
    ///         }
    ///         HStack {
    ///             Text(" Slider").tint(.green)
    ///             Slider(value: $sliderValue, in: -100...100, step: 0.1)
    ///         }
    ///     }.preferredColorScheme(.dark)
    ///
    /// - Parameter colorScheme: The color scheme for this view.
    ///
    /// - Returns: A view that wraps this view and sets the color scheme.
//    @inlinable
//    func preferredColorScheme(
//        _ colorScheme: ColorScheme?
//    ) -> ModifiedContent<Self, _PreferenceWritingModifier<PreferredColorSchemeKey>> {
//        preference(key: PreferredColorSchemeKey.self, value: colorScheme)
//    }
}

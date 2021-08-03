//
// Created by Mike on 7/31/21.
//

//private struct ButtonStyleKey: EnvironmentKey {
//    static let defaultValue: SomeButtonStyle = DefaultButtonStyle()
//}
//
//extension EnvironmentValues {
//    var buttonStyle: SomeButtonStyle {
//        get { self[ButtonStyleKey.self] }
//        set { self[ButtonStyleKey.self] = newValue }
//    }
//}
//
////extension ViewModifiers {
////    public struct _ButtonStyle<Style: ButtonStyle>: ViewModifier {
////        public let buttonStyle: Style
////
////        @inlinable
////        public init(buttonStyle: Style) {
////            self.buttonStyle = buttonStyle
////        }
////    }
////
////    public struct _PrimitiveButtonStyle<Style: PrimitiveButtonStyle>
////        : ViewModifier {
////        public let buttonStyle: Style
////
////        @inlinable
////        public init(buttonStyle: Style) {
////            self.buttonStyle = buttonStyle
////        }
////    }
////}
//
//extension View {
//    /// Sets the style for buttons within this view to a button style with a
//    /// custom appearance and standard interaction behavior.
//    ///
//    /// Use this modifier to set a specific style for all button instances
//    /// within a view:
//    ///
//    /// ```swift
//    /// HStack {
//    ///     Button("Sign In", action: signIn)
//    ///     Button("Register", action: register)
//    /// }
//    /// .buttonStyle(BorderedButtonStyle())
//    /// ```
//    public func buttonStyle<S>(
//        _ style: S
//    ) -> ModifiedContent<Self, ViewModifiers._EnvironmentValue>
//        where S: ButtonStyle {
//        environment(\.buttonStyle, style)
//    }
//
//    /// Sets the style for buttons within this view to a button style with a
//    /// custom appearance and custom interaction behavior.
//    ///
//    /// Use this modifier to set a specific style for button instances within a
//    /// view:
//    ///
//    /// ```swift
//    /// HStack {
//    ///     Button("Sign In", action: signIn)
//    ///     Button("Register", action: register)
//    /// }
//    /// .buttonStyle(BorderedButtonStyle())
//    /// ```
//    func buttonStyle<S>(
//        _ style: S
//    ) -> ModifiedContent<Self, ViewModifiers._EnvironmentValue>
//        where S : PrimitiveButtonStyle {
//        environment(\.buttonStyle, style)
//    }
//}
//
////extension ViewModifiers._ButtonStyle: UIKitNodeModifierResolvable {
////    private class Node: UIKitNodeModifier {
////        var hierarchyIdentifier: String {
////            ""
////        }
////
////        func update(
////            viewModifier: ViewModifiers._ButtonStyle<Style>,
////            context: inout Context
////        ) {
////        }
////    }
////
////    func resolve(context: Context, cachedNodeModifier: AnyUIKitNodeModifier?) -> AnyUIKitNodeModifier {
////        (cachedNodeModifier as? Node) ?? Node()
////    }
////}

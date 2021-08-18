//
// Created by Mike on 7/31/21.
//

/// The foreground style in the current context.
///
/// You can also use ``ShapeStyle/foreground`` to construct this style.
public struct ForegroundStyle: ShapeStyle {
    public init() {}

    public func _apply(to shape: inout _ShapeStyle_Shape) {
        if let foregroundStyle = shape.environment._foregroundStyle {
            foregroundStyle._apply(to: &shape)
        } else {
            shape.result = .color(shape.environment.foregroundColor ?? .primary)
        }
    }

    public static func _apply(to shape: inout _ShapeStyle_ShapeType) {}
}

extension ForegroundStyle: ShapeStyleRenderable {
    func render(to layer: CAShapeLayer, context: Context) {
        (context.environment.foregroundColor ?? .primary)
            .render(to: layer, context: context)
    }
}

extension ShapeStyle where Self == ForegroundStyle {

    /// The foreground style in the current context.
    ///
    /// Access this value to get the style SwiftUI uses for foreground elements,
    /// like text, symbols, and shapes, in the current context. Use the
    /// ``View/foregroundStyle(_:)`` modifier to set a new foreground style for
    /// a given view and its child views.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    public static var foreground: ForegroundStyle {
        get { .init() }
    }
}

extension EnvironmentValues {
    private struct ForegroundStyleKey: EnvironmentKey {
        static let defaultValue: ForegroundStyle? = nil
    }

    public var _foregroundStyle: ForegroundStyle? {
        get {
            self[ForegroundStyleKey.self]
        }
        set {
            self[ForegroundStyleKey.self] = newValue
        }
    }
}

extension View {

    @inlinable
    public func foregroundStyle<S>(
        _ style: S
    ) -> ModifiedContent<Self, _ForegroundStyleModifier<S>>
        where S: ShapeStyle {
        modifier(_ForegroundStyleModifier(style: style))
    }

    @inlinable
    public func foregroundStyle<S1, S2>(
        _ primary: S1,
        _ secondary: S2
    ) -> ModifiedContent<Self, _ForegroundStyleModifier2<S1, S2>>
        where S1: ShapeStyle, S2: ShapeStyle {
        modifier(
            _ForegroundStyleModifier2(primary: primary, secondary: secondary)
        )
    }

    @inlinable
    public func foregroundStyle<S1, S2, S3>(
        _ primary: S1,
        _ secondary: S2,
        _ tertiary: S3
    ) -> ModifiedContent<Self, _ForegroundStyleModifier3<S1, S2, S3>>
        where S1: ShapeStyle, S2: ShapeStyle, S3: ShapeStyle {
        modifier(
            _ForegroundStyleModifier3(
                primary: primary,
                secondary: secondary,
                tertiary: tertiary
            )
        )
    }
}

public struct _ForegroundStyleModifier<Style> where Style : ShapeStyle {
    public var style: Style

    @inlinable
    public init(style: Style) {
        self.style = style
    }

    public typealias Body = Swift.Never
}

public struct _ForegroundStyleModifier2<S1, S2>
    where S1: ShapeStyle, S2: ShapeStyle {
    public var primary: S1
    public var secondary: S2

    @inlinable
    public init(primary: S1, secondary: S2) {
        self.primary = primary
        self.secondary = secondary
    }

    public typealias Body = Swift.Never
}

public struct _ForegroundStyleModifier3<S1, S2, S3>
    where S1: ShapeStyle, S2: ShapeStyle, S3: ShapeStyle {
    public var primary: S1
    public var secondary: S2
    public var tertiary: S3

    @inlinable
    public init(primary: S1, secondary: S2, tertiary: S3) {
        (self.primary, self.secondary, self.tertiary) = (primary, secondary, tertiary)
    }

    public typealias Body = Never

    // TODO:
//    public func modifyEnvironment(_ values: inout EnvironmentValues) {
//        values._foregroundStyle = .init(styles: (primary, secondary, tertiary), environment: values)
//    }
}

extension _ForegroundStyleModifier: ViewModifier {}
extension _ForegroundStyleModifier2: ViewModifier {}
extension _ForegroundStyleModifier3: ViewModifier {}

//
// Created by Mike on 7/31/21.
//

public struct BackgroundStyle: ShapeStyle {
    @inlinable public init() {}

    public func _apply(to shape: inout _ShapeStyle_Shape) {
        if let backgroundStyle = shape.environment._backgroundStyle {
            backgroundStyle._apply(to: &shape)
        } else {
            shape.result = .none
        }
    }
}

extension ShapeStyle where Self == BackgroundStyle {

    /// The background style in the current context.
    ///
    /// Access this value to get the style SwiftUI uses for the background
    /// in the current context. The specific color that SwiftUI renders depends
    /// on factors like the platform and whether the user has turned on Dark
    /// Mode.
    ///
    /// For information about how to use shape styles, see ``ShapeStyle``.
    public static var background: BackgroundStyle {
        .init()
    }
}

extension EnvironmentValues {
    private struct BackgroundStyleKey: EnvironmentKey {
        static let defaultValue: BackgroundStyle? = nil
    }

    public var _backgroundStyle: BackgroundStyle? {
        get {
            self[BackgroundStyleKey.self]
        }
        set {
            self[BackgroundStyleKey.self] = newValue
        }
    }
}

public extension View {
    @inlinable
    func background(
        ignoresSafeAreaEdges edges: Edge.Set = .all
    ) -> ModifiedContent<Self, _BackgroundStyleModifier<BackgroundStyle>> {
        modifier(
            _BackgroundStyleModifier(
                style: BackgroundStyle(),
                ignoresSafeAreaEdges: edges
            )
        )
    }

    @inlinable
    func background<S>(
        _ style: S,
        ignoresSafeAreaEdges edges: Edge.Set = .all
    ) -> ModifiedContent<Self, _BackgroundStyleModifier<S>>
        where S: ShapeStyle {
        modifier(
            _BackgroundStyleModifier(
                style: style,
                ignoresSafeAreaEdges: edges
            )
        )
    }
}

public struct _BackgroundStyleModifier<Style>: ViewModifier, EnvironmentReader
    where Style: ShapeStyle {

    public var environment: EnvironmentValues!

    public let style: Style
    public let ignoresSafeAreaEdges: Edge.Set

    @inlinable
    public init(style: Style, ignoresSafeAreaEdges: Edge.Set) {
        self.style = style
        self.ignoresSafeAreaEdges = ignoresSafeAreaEdges
    }

    public typealias Body = Never
    public mutating func setContent(from values: EnvironmentValues) {
        environment = values
    }

    // TODO:
//    public func modifyEnvironment(_ values: inout EnvironmentValues) {
//        values._backgroundStyle = .init(style)
//    }
}

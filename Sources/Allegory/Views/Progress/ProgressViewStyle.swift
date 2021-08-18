//
// Created by Mike on 8/14/21.
//

public protocol SomeProgressViewStyle {
    @ViewBuilder func makeBody(configuration: Any) -> SomeView
}

public protocol ProgressViewStyle: SomeProgressViewStyle {
    associatedtype Body: View
    typealias Configuration = ProgressViewStyleConfiguration

    @ViewBuilder
    func makeBody(configuration: Self.Configuration) -> SomeView
}

extension ProgressViewStyle {
    public func makeBody(configuration: Any) -> SomeView {
        makeBody(configuration: (configuration as! Self.Configuration))
    }

    public func makeBody(configuration: Configuration) -> SomeView {
        abstractMethod()
    }
}

extension ProgressViewStyle where Body == Never {}

public struct ProgressViewStyleConfiguration {
    /// A type-erased label describing the task represented by the progress
    /// view.
    public struct Label: View {
        public let body: AnyView
    }

    /// A type-erased label that describes the current value of a progress view.
    public struct CurrentValueLabel: View {
        public let body: AnyView
    }

    /// The completed fraction of the task represented by the progress view,
    /// from `0.0` (not yet started) to `1.0` (fully complete), or `nil` if the
    /// progress is indeterminate.
    public let fractionCompleted: Double?

    /// A view that describes the task represented by the progress view.
    ///
    /// If `nil`, then the task is self-evident from the surrounding context,
    /// and the style does not need to provide any additional description.
    ///
    /// If the progress view is defined using a `Progress` instance, then this
    /// label is equivalent to its `localizedDescription`.
    public var label: ProgressViewStyleConfiguration.Label?

    /// A view that describes the current value of a progress view.
    ///
    /// If `nil`, then the value of the progress view is either self-evident
    /// from the surrounding context or unknown, and the style does not need to
    /// provide any additional description.
    ///
    /// If the progress view is defined using a `Progress` instance, then this
    /// label is equivalent to its `localizedAdditionalDescription`.
    public var currentValueLabel: ProgressViewStyleConfiguration.CurrentValueLabel?
}

public struct DefaultProgressViewStyle: ProgressViewStyle {
    public typealias Body = Never

    public init() {}

    @ViewBuilder
    public func makeBody(configuration: Configuration) -> SomeView {
        VStack(alignment: .leading, spacing: 0) {
            HStack { Spacer() }
            configuration.label
                .foregroundStyle(HierarchicalShapeStyle.primary)
            if let fractionCompleted = configuration.fractionCompleted {
                _FractionalProgressView(fractionCompleted)
            } else {
                _IndeterminateProgressView()
            }
            configuration.currentValueLabel
                .font(.caption)
                .foregroundStyle(HierarchicalShapeStyle.primary)
                .opacity(0.5)
        }
    }
}

public struct _AnyProgressViewStyle: ProgressViewStyle {
    public typealias Body = Never

    private let bodyClosure: (ProgressViewStyleConfiguration) -> SomeView
    public let type: Any.Type

    public init<S: ProgressViewStyle>(_ style: S) {
        type = S.self
        bodyClosure = { configuration in
            style.makeBody(configuration: configuration)
        }
    }

//    public func makeBody(
//        configuration: Configuration
//    ) -> SomeView {
//        bodyClosure(configuration)
//    }
}

extension EnvironmentValues {
    private enum ProgressViewStyleKey: EnvironmentKey {
        static let defaultValue = _AnyProgressViewStyle(DefaultProgressViewStyle())
    }

    var progressViewStyle: _AnyProgressViewStyle {
        get {
            self[ProgressViewStyleKey.self]
        }
        set {
            self[ProgressViewStyleKey.self] = newValue
        }
    }
}

extension View {

    /// Sets the style for progress views in this view.
    ///
    /// For example, the following code creates a progress view that uses the
    /// "circular" style:
    ///
    ///     ProgressView()
    ///         .progressViewStyle(CircularProgressViewStyle())
    ///
    /// - Parameter style: The progress view style to use for this view.
    public func progressViewStyle<S>(
        _ style: S
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<_AnyProgressViewStyle>>
        where S: ProgressViewStyle {
        environment(\.progressViewStyle, .init(style))
    }
}

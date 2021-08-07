//
// Created by Mike on 8/3/21.
//

public protocol SomeProgressViewStyle {
    @ViewBuilder func makeBody(configuration: Any) -> SomeView
}

/// A type that applies standard interaction behavior to all progress views
/// within a view hierarchy.
///
/// To configure the current progress view style for a view hierarchy, use the
/// ``View/progressViewStyle(_:)`` modifier.
public protocol ProgressViewStyle: SomeProgressViewStyle {
    /// A view representing the body of a progress view.
    associatedtype Body : View

    /// Creates a view representing the body of a progress view.
    ///
    /// The view hierarchy calls this method for each progress view where this
    /// style is the current progress view style.
    ///
    /// - Parameter configuration: The properties of the progress view, such as
    ///   its preferred progress type.
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body

    /// A type alias for the properties of a progress view instance.
    typealias Configuration = ProgressViewStyleConfiguration
}

struct AnyProgressViewStyle<Style>: ProgressViewStyle where Style: ProgressViewStyle {

    let style: Style

    func makeBody(configuration: Configuration) -> Style.Body {
        style.makeBody(configuration: configuration)
    }

    init(_ style: Style) {
        self.style = style
    }
}

extension ProgressViewStyle {
    @ViewBuilder
    public func makeBody(configuration: Any) -> SomeView {
        makeBody(configuration: (configuration as! Self.Configuration))
    }
}

public struct ProgressViewStyleConfiguration {
    /// A type-erased label describing the task represented by the progress
    /// view.
    public struct Label: View {
        public typealias Body = Never

        internal let view: SomeView
        init<V>(_ view: V) where V: View {
            self.view = view
        }
    }

    /// A type-erased label that describes the current value of a progress view.
    public struct CurrentValueLabel: View {
        public typealias Body = Never

        internal let view: SomeView
        init<V>(_ view: V) where V: View {
            self.view = view
        }
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

extension ProgressViewStyleConfiguration.Label: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        view.resolve(context: context, cachedNode: cachedNode)
    }
}

extension ProgressViewStyleConfiguration.CurrentValueLabel: UIKitNodeResolvable {
    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        view.resolve(context: context, cachedNode: cachedNode)
    }
}

public struct CircularProgressViewStyle: ProgressViewStyle {

    private let tint: Color

    public init() {
        self.init(tint: .gray)
    }

    public init(tint: Color) {
        self.tint = tint
    }

    public func makeBody(
        configuration: Configuration
    ) -> _CircularProgressView {
        _CircularProgressView(tint: tint)
    }
}

public struct _CircularProgressView: View {
    internal let tint: Color
}

//
// Created by Mike on 8/3/21.
//

import UIKit

/// A view that shows the progress towards completion of a task.
///
/// Use a progress view to show that a task is making progress towards
/// completion. A progress view can show both determinate (percentage complete)
/// and indeterminate (progressing or not) types of progress.
///
/// Create a determinate progress view by initializing a `ProgressView` with
/// a binding to a numeric value that indicates the progress, and a `total`
/// value that represents completion of the task. By default, the progress is
/// `0.0` and the total is `1.0`.
///
/// The example below uses the state property `progress` to show progress in
/// a determinate `ProgressView`. The progress view uses its default total of
/// `1.0`, and because `progress` starts with an initial value of `0.5`,
/// the progress view begins half-complete. A "More" button below the progress
/// view allows the user to increment the progress in 5% increments:
///
///     @State private var progress = 0.5
///
///     VStack {
///         ProgressView(value: progress)
///         Button("More", action: { progress += 0.05 })
///     }
///
/// To create an indeterminate progress view, use an initializer that doesn't
/// take a progress value:
///
///     var body: some View {
///         ProgressView()
///     }
///
/// ### Styling Progress Views
///
/// You can custpublic omize the appearance and interaction of progress views by
/// creating styles that conform to the ``ProgressViewStyle`` protocol. To set a
/// specific style for all progress view instances within a view, use the
/// ``View/progressViewStyle(_:)`` modifier. In the following example, a custom
/// style adds a dark blue shadow to all progress views within the enclosing
/// ``VStack``:
///
///     struct ShadowedProgressViews: View {
///         var body: some View {
///             VStack {
///                 ProgressView(value: 0.25)
///                 ProgressView(value: 0.75)
///             }
///             .progressViewStyle(DarkBlueShadowProgressViewStyle())
///         }
///     }
///
///     struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
///         func makeBody(configuration: Configuration) -> some View {
///             ProgressView(configuration)
///                 .shadow(color: Color(red: 0, green: 0, blue: 0.6),
///                         radius: 4.0, x: 1.0, y: 2.0)
///         }
///     }
///
public struct ProgressView<Label, CurrentValueLabel>: View
    where Label: View, CurrentValueLabel: View {

    let storage: Storage

    enum Storage {
        case custom(_CustomProgressView<Label, CurrentValueLabel>)
        case foundation(_FoundationProgressView)
    }

    @ViewBuilder
    public var body: SomeView {
        switch storage {
        case let .custom(custom): custom
        case let .foundation(foundation): foundation
        }
    }
}

public struct _CustomProgressView<Label, CurrentValueLabel>: View
    where Label: View, CurrentValueLabel: View
{
    var fractionCompleted: Double?
    var label: Label?
    var currentValueLabel: CurrentValueLabel?

    @Environment(\.progressViewStyle) var style

    init(
        fractionCompleted: Double?,
        label: Label?,
        currentValueLabel: CurrentValueLabel?
    ) {
        self.fractionCompleted = fractionCompleted
        self.label = label
        self.currentValueLabel = currentValueLabel
    }

    public var body: SomeView {
        style.makeBody(
            configuration: .init(
                fractionCompleted: fractionCompleted,
                label: label.map { .init(body: AnyView($0)) },
                currentValueLabel: currentValueLabel.map { .init(body: AnyView($0)) }
            )
        )
    }
}

public struct _FoundationProgressView: View {
    let progress: Progress
    @State private var state: ProgressState?

    struct ProgressState {
        var progress: Double
        var isIndeterminate: Bool
        var description: String
    }

    init(_ progress: Progress) {
        self.progress = progress
    }

    public var body: ProgressView<Text, Text> {
        ProgressView(
            value: progress.isIndeterminate ? nil : progress.fractionCompleted
        ) {
            Text("\(Int(progress.fractionCompleted * 100))% completed")
        } currentValueLabel: {
            Text("\(progress.completedUnitCount)/\(progress.totalUnitCount)")
        }
    }
}

/// Override in renderers to provide a default body for determinate progress views.
public struct _FractionalProgressView: View, _PrimitiveView {
    public let fractionCompleted: Double
    init(_ fractionCompleted: Double) {
        self.fractionCompleted = fractionCompleted
    }

    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        TODO()
    }

    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        TODO()
    }
}

/// Override in renderers to provide a default body for indeterminate progress views.
public struct _IndeterminateProgressView: View, _PrimitiveView {
    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
        TODO()
    }

    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
        TODO()
    }
}

extension ProgressView where CurrentValueLabel == EmptyView {
    /// Creates a progress view for showing indeterminate progress, without a
    /// label.
    public init() where Label == EmptyView {
        self.init(storage: .custom(
            .init(fractionCompleted: nil, label: nil, currentValueLabel: nil)
        ))
    }

    /// Creates a progress view for showing indeterminate progress that displays
    /// a custom label.
    ///
    /// - Parameters:
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    public init(@ViewBuilder label: () -> Label) {
        self.init(storage: .custom(
            .init(fractionCompleted: nil, label: label(), currentValueLabel: nil)
        ))
    }

    /// Creates a progress view for showing indeterminate progress that
    /// generates its label from a string.
    ///
    /// - Parameters:
    ///     - title: A string that describes the task in progress.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(verbatim:)``. See ``Text`` for more
    /// information about localizing strings. To initialize a progress view with
    /// a localized string key, use the corresponding initializer that takes a
    /// `LocalizedStringKey` instance.
    public init<S>(_ title: S) where Label == Text, S: StringProtocol {
        self.init {
            Text(title)
        }
    }
}

extension ProgressView {

    /// Creates a progress view for showing determinate progress.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<V>(
        value: V?,
        total: V = 1.0
    ) where Label == EmptyView, CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.init(storage: .custom(
            .init(
                fractionCompleted: value.map { Double($0 / total) },
                label: nil,
                currentValueLabel: nil
            )
        ))
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    public init<V>(
        value: V?,
        total: V = 1.0,
        @ViewBuilder label: () -> Label
    ) where CurrentValueLabel == EmptyView, V: BinaryFloatingPoint {
        self.init(storage: .custom(
            .init(
                fractionCompleted: value.map { Double($0 / total) },
                label: label(),
                currentValueLabel: nil
            )
        ))
    }

    /// Creates a progress view for showing determinate progress, with a
    /// custom label.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// - Parameters:
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    ///     - label: A view builder that creates a view that describes the task
    ///       in progress.
    ///     - currentValueLabel: A view builder that creates a view that
    ///       describes the level of completed progress of the task.
    public init<V>(
        value: V?,
        total: V = 1.0,
        @ViewBuilder label: () -> Label,
        @ViewBuilder currentValueLabel: () -> CurrentValueLabel
    ) where V: BinaryFloatingPoint {
        self.init(storage: .custom(
            .init(
                fractionCompleted: value.map { Double($0 / total) },
                label: label(),
                currentValueLabel: currentValueLabel()
            )
        ))
    }

    /// Creates a progress view for showing determinate progress that generates
    /// its label from a string.
    ///
    /// If the value is non-`nil`, but outside the range of `0.0` through
    /// `total`, the progress view pins the value to those limits, rounding to
    /// the nearest possible bound. A value of `nil` represents indeterminate
    /// progress, in which case the progress view ignores `total`.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(verbatim:)``. See ``Text`` for more
    /// information about localizing strings. To initialize a determinate
    /// progress view with a localized string key, use the corresponding
    /// initializer that takes a `LocalizedStringKey` instance.
    ///
    /// - Parameters:
    ///     - title: The string that describes the task in progress.
    ///     - value: The completed amount of the task to this point, in a range
    ///       of `0.0` to `total`, or `nil` if the progress is
    ///       indeterminate.
    ///     - total: The full amount representing the complete scope of the
    ///       task, meaning the task is complete if `value` equals `total`. The
    ///       default value is `1.0`.
    public init<S, V>(
        _ title: S,
        value: V?,
        total: V = 1.0
    ) where Label == Text, CurrentValueLabel == EmptyView, S: StringProtocol, V: BinaryFloatingPoint {
        self.init(
            value: value,
            total: total
        ) {
            Text(title)
        }
    }
}

extension ProgressView {

    /// Creates a progress view based on a style configuration.
    ///
    /// You can use this initializer within the
    /// ``ProgressViewStyle/makeBody(configuration:)`` method of a
    /// ``ProgressViewStyle`` to create an instance of the styled progress view.
    /// This is useful for custom progress view styles that only modify the
    /// current progress view style, as opposed to implementing a brand new
    /// style.
    ///
    /// For example, the following style adds a dark blue shadow to the progress
    /// view, but otherwise preserves the progress view's current style:
    ///
    ///     struct DarkBlueShadowProgressViewStyle: ProgressViewStyle {
    ///         func makeBody(configuration: Configuration) -> some View {
    ///             ProgressView(configuration)
    ///                 .shadow(color: Color(red: 0, green: 0, blue: 0.6),
    ///                         radius: 4.0, x: 1.0, y: 2.0)
    ///         }
    ///     }
    ///
    public init(_ configuration: ProgressViewStyleConfiguration)
        where Label == ProgressViewStyleConfiguration.Label,
        CurrentValueLabel == ProgressViewStyleConfiguration.CurrentValueLabel
    {
        self.init(value: configuration.fractionCompleted) {
            ProgressViewStyleConfiguration.Label(
                body: AnyView(configuration.label)
            )
        } currentValueLabel: {
            ProgressViewStyleConfiguration.CurrentValueLabel(
                body: AnyView(configuration.currentValueLabel)
            )
        }
    }
}

extension ProgressView: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "ProgressView"
        }

        var progressView: UIProgressView?
        var activityIndicator: UIActivityIndicatorView?

        func update(view: ProgressView, context: Context) {
            activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            TODO()
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            TODO()
        }
    }

    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        TODO()
//        if let style = context.environment._progressViewStyle {
//            context.environment._progressViewStyle = nil
//            defer {
//                context.environment._progressViewStyle = style
//            }
//            let configuration = makeConfiguration()
//            return style.makeBody(configuration: configuration)
//                .resolve(context: context, cachedNode: cachedNode)
//        } else {
//            return (cachedNode as? Node) ?? Node()
//        }
    }
}

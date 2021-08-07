//
// Created by Mike on 7/29/21.
//

/// A collection of environment values propagated through a view hierarchy.
public struct EnvironmentValues {

    private var values: [String: Any] = [:]

    /// Accesses the environment value associated with a custom key.
    ///
    /// Create custom environment values by defining a key that conforms to the
    /// ``EnvironmentKey`` protocol, and then using that key with the subscript
    /// operator of the ``EnvironmentValues`` structure to get and set a value
    /// for that key:
    ///
    /// ```swift
    /// private struct MyEnvironmentKey: EnvironmentKey {
    ///     static let defaultValue: String = "Default value"
    /// }
    ///
    /// extension EnvironmentValues {
    ///     var myCustomValue: String {
    ///         get { self[MyEnvironmentKey.self] }
    ///         set { self[MyEnvironmentKey.self] = newValue }
    ///     }
    /// }
    /// ```
    ///
    /// You use custom environment values the same way you use system-provided
    /// values, setting a value with the ``environment(_:_:)`` view modifier,
    /// and reading values with the ``Environment`` property wrapper. You can
    /// also provide a dedicated view modifier as a convenience for setting the
    /// value:
    ///
    /// ```swift
    /// extension View {
    ///     func myCustomValue(_ myCustomValue: String) -> some View {
    ///         environment(\.myCustomValue, myCustomValue)
    ///     }
    /// }
    /// ```
    public subscript<K>(key: K.Type) -> K.Value where K : EnvironmentKey {
        get {
            values[String(describing: key)] as! K.Value
        }
        mutating set {
            values[String(describing: key)] = newValue
        }
    }

    /// The current calendar that views should use when handling dates.
    public var calendar: Calendar = Calendar.autoupdatingCurrent

    /// The current locale that views should use.
    public var locale: Locale = Locale.autoupdatingCurrent

    /// The current time zone that views should use when handling dates.
    public var timeZone: TimeZone = TimeZone.autoupdatingCurrent

    public var foregroundColor: Color? = Color.black

    public var accentColor: Color? = Color.blue

    public var vStackSpacing: Double = 10

    public var hStackSpacing: Double = 10

    public var padding: Double = 10

    /// The default font of this environment.
    public var font: Font = .body

    /// A value that indicates how text instance aligns its lines when the
    /// content wraps or contains newlines.
    ///
    /// Use alignment parameters on a parent view to align ``Text`` with respect
    /// to its parent. Because the horizontal bounds of ``TextField`` never
    /// exceed its graphical extent, this value has little to no effect on
    /// single-line text.
    public var multilineTextAlignment: TextAlignment = .leading

    /// A value that indicates how the layout truncates the last line of text to
    /// fit into the available space.
    ///
    /// The default value is ``Text/TruncationMode/tail``.
    public var truncationMode: Text.TruncationMode = .tail

    /// The distance in points between the bottom of one line fragment and the
    /// top of the next.
    ///
    /// This value is always nonnegative.
    public var lineSpacing: Double = 0

    /// A Boolean value that indicates whether inter-character spacing should
    /// tighten to fit the text into the available space.
    ///
    /// The default value is `false`.
    public var allowsTightening: Bool = false

    /// The maximum number of lines that text can occupy in a view.
    ///
    /// The maximum number of lines is `1` if the value is less than `1`. If the
    /// value is `nil`, the text uses as many lines as required. The default is
    /// `nil`.
    public var lineLimit: Int? = nil

    /// The minimum permissible proportion to shrink the font size to fit the
    /// text into the available space.
    ///
    /// You can set the minimum scale factor to any value greater than `0` and
    /// less than or equal to `1`. The default value is `1`.
    public var minimumScaleFactor: Double = 1

    // MARK: Private

    public var _layoutAxis: Axis? = nil

    public var _progressViewStyle: SomeProgressViewStyle? = CircularProgressViewStyle()
}

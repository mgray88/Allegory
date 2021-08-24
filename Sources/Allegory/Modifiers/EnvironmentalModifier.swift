//
// Created by Mike on 8/22/21.
//

/// A modifier that must resolve to a concrete modifier in an environment before
/// use.
public protocol EnvironmentalModifier: ViewModifier where Self.Body == Never {

    /// The type of modifier to use after being resolved.
    associatedtype ResolvedModifier: ViewModifier

    /// Resolve to a concrete modifier in the given `environment`.
    func resolve(in environment: EnvironmentValues) -> Self.ResolvedModifier

    static var _requiresMainThread: Bool { get }
}

extension EnvironmentalModifier {
    public static var _requiresMainThread: Bool {
        true
    }
}

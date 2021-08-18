//
// Created by Mike on 8/14/21.
//

/// Allows "late-binding tokens" to be resolved in an environment
public protocol AnyTokenBox: AnyObject {
    associatedtype ResolvedValue
    func resolve(in environment: EnvironmentValues) -> ResolvedValue
}

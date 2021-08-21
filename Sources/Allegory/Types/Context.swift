//
// Created by Mike on 7/29/21.
//

public struct Context {
    public var environment: EnvironmentValues = .init()

    public var environmentObjects: [String: Any] = [:]

    public var renderer: Renderer? = nil

    public init() {}
}

extension Context {
    @inlinable
    public func environmentObject<B>(_ object: B) -> Context {
        var copy = self
        copy.environmentObjects[String(reflecting: B.self)] = object
        return copy
    }
}

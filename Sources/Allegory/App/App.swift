//
// Created by Mike on 8/15/21.
//

import RxSwift

public protocol SomeApp {
    @SceneBuilder
    var body: SomeScene { get }
}

/// The renderer is responsible for implementing certain functionality.
public protocol App: SomeApp {
    associatedtype Body: Scene

    @SceneBuilder
    var body: Body { get }

    /// Implemented by the renderer to mount the `App`
    static func _launch(_ app: Self, _ rootEnvironment: EnvironmentValues)

    /// Implemented by the renderer to update the `App` on `ScenePhase` changes
//    var _phasePublisher: Infallible<ScenePhase> { get }

    /// Implemented by the renderer to update the `App` on `ColorScheme` changes
//    var _colorSchemePublisher: Infallible<ColorScheme> { get }

    static func main()

    init()
}

extension App {
    public static func main() {
        let app = Self()
        _launch(app, EnvironmentValues())
    }
}

extension App where Body == Never {
    public var body: Self.Body {
        fatalError()
    }
}

//
// Created by Mike on 8/15/21.
//

import RxSwift

/// Provides the ability to set the title of the Scene.
public protocol _TitledApp {
    static func _setTitle(_ title: String)
}

/// The renderer is responsible for implementing certain functionality.
public protocol App: _TitledApp {
    associatedtype Body: Scene

    @SceneBuilder
    var body: Body { get }

    /// Implemented by the renderer to mount the `App`
    static func _launch(_ app: Self, _ rootEnvironment: EnvironmentValues)

    /// Implemented by the renderer to update the `App` on `ScenePhase` changes
    var _phasePublisher: Infallible<ScenePhase> { get }

    /// Implemented by the renderer to update the `App` on `ColorScheme` changes
    var _colorSchemePublisher: Infallible<ColorScheme> { get }

    static func main()

    init()
}

extension App {
    public static func main() {
        let app = Self()
        _launch(app, EnvironmentValues())
    }
}

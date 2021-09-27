//
// Created by Mike on 8/15/21.
//

import RxSwift
import UIKit

public protocol SomeApp {
    @SceneBuilder
    var body: SomeScene { get }
}

/// A type that represents the structure and behavior of an app.
///
/// Create an app by declaring a structure that conforms to the `App` protocol.
/// Implement the required ``Allegory/App/body-swift.property`` computed property
/// to define the app's content:
///
///     @main
///     struct MyApp: App {
///         var body: some Scene {
///             WindowGroup {
///                 Text("Hello, world!")
///             }
///         }
///     }
///
/// Precede the structure's declaration with the
/// [@main](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID626)
/// attribute to indicate that your custom `App` protocol conformer provides the
/// entry point into your app. The protocol provides a default implementation of
/// the ``Allegory/App/main()`` method that the system calls to launch your app.
/// You can have exactly one entry point among all of your app's files.
///
/// Compose the app's body from instances that conform to the ``Allegory/Scene``
/// protocol. Each scene contains the root view of a view hierarchy and has a
/// life cycle managed by the system. Allegory provides some concrete scene types
/// to handle common scenarios, like for displaying documents or settings. You
/// can also create custom scenes.
///
///     @main
///     struct Mail: App {
///         var body: some Scene {
///             WindowGroup {
///                 MailViewer()
///             }
///             Settings {
///                 SettingsView()
///             }
///         }
///     }
///
/// You can declare state in your app to share across all of its scenes. For
/// example, you can use the ``Allegory/StateObject`` attribute to initialize a
/// data model, and then provide that model on a view input as an
/// ``Allegory/ObservedObject`` or through the environment as an
/// ``Allegory/EnvironmentObject`` to scenes in the app:
///
///     @main
///     struct Mail: App {
///         @StateObject private var model = MailModel()
///
///         var body: some Scene {
///             WindowGroup {
///                 MailViewer()
///                     .environmentObject(model) // Passed through the environment.
///             }
///             Settings {
///                 SettingsView(model: model) // Passed as an observed object.
///             }
///         }
///     }
///
public protocol App: SomeApp {
    associatedtype Body: Scene

    @SceneBuilder
    var body: Body { get }

    init()

    /// Implemented by the renderer to update the `App` on `ScenePhase` changes
//    var _phasePublisher: Infallible<ScenePhase> { get }

    /// Implemented by the renderer to update the `App` on `ColorScheme` changes
//    var _colorSchemePublisher: Infallible<ColorScheme> { get }
}

extension App {
    public static func main() {
        let app: Self = Self()
        runApp(app: app)

//        let appDelegate = AppDelegate()
//
//        let mirror = Mirror(reflecting: app)
//        for property in mirror.children where property.value is UIApplicationDelegateProperty {
//            appDelegate.consumerDelegate = (property.value as! UIApplicationDelegateProperty).delegate
//        }
    }
}

extension App where Body == Never {
    public var body: Self.Body {
        fatalError()
    }
}

internal func runApp<Content>(app: Content) where Content: App {
    let appGraph = AppGraph(app: app)
    AppGraph.shared = appGraph

    UIApplicationMain(
        CommandLine.argc,
        CommandLine.unsafeArgv,
        NSStringFromClass(UIApplication.self),
        NSStringFromClass(AppDelegate.self)
    )
}

internal class AppNode {
    internal static private(set) var main: AppNode!

    let app: SomeApp
    let appType: Any.Type

    weak var appDelegate: AppDelegate!

    init<Content>(_ app: Content) where Content: App {
        self.app = app
        self.appType = Content.self
        AppNode.main = self
    }
}

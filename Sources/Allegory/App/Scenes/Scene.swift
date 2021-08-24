//
// Created by Mike on 8/15/21.
//

public protocol SomeScene {
    var body: SomeScene { get }
}

/// A part of an app's user interface with a life cycle managed by the
/// system.
///
/// You create an ``Allegory/App`` by combining one or more instances
/// that conform to the `Scene` protocol in the app's
/// ``Allegory/App/body-swift.property``. You can use the primitive scenes that
/// Allegory provides, like ``Allegory/WindowGroup``, along with custom scenes
/// that you compose from other scenes. To create a custom scene, declare a
/// type that conforms to the `Scene` protocol. Implement the required
/// ``Allegory/Scene/body-swift.property`` computed property and provide the
/// content for your custom scene:
///
///     struct MyScene: Scene {
///         var body: some Scene {
///             WindowGroup {
///                 MyRootView()
///             }
///         }
///     }
///
/// A scene acts as a container for a view hierarchy that you want to display
/// to the user. The system decides when and how to present the view hierarchy
/// in the user interface in a way that's platform-appropriate and dependent
/// on the current state of the app. For example, for the window group shown
/// above, the system lets the user create or remove windows that contain
/// `MyRootView` on platforms like macOS and iPadOS. On other platforms, the
/// same view hierarchy might consume the entire display when active.
///
/// Read the ``Allegory/EnvironmentValues/scenePhase`` environment
/// value from within a scene or one of its views to check whether a scene is
/// active or in some other state. You can create a property that contains the
/// scene phase, which is one of the values in the ``Allegory/ScenePhase``
/// enumeration, using the ``Allegory/Environment`` attribute:
///
///     struct MyScene: Scene {
///         @Environment(\.scenePhase) private var scenePhase
///
///         // ...
///     }
///
/// The `Scene` protocol provides scene modifiers, defined as protocol methods
/// with default implementations, that you use to configure a scene. For
/// example, you can use the ``Allegory/Scene/onChange(of:perform:)`` modifier to
/// trigger an action when a value changes. The following code empties a cache
/// when all of the scenes in the window group have moved to the background:
///
///     struct MyScene: Scene {
///         @Environment(\.scenePhase) private var scenePhase
///         @StateObject private var cache = DataCache()
///
///         var body: some Scene {
///             WindowGroup {
///                 MyRootView()
///             }
///             .onChange(of: scenePhase) { newScenePhase in
///                 if newScenePhase == .background {
///                     cache.empty()
///                 }
///             }
///         }
///     }
public protocol Scene: SomeScene {
    associatedtype Body: Scene

    @SceneBuilder
    var body: Self.Body { get }
}

protocol TitledScene {
    var title: Text? { get }
}

extension Scene {
    public var body: SomeScene {
        (body as Body) as SomeScene
    }
}

extension Scene where Body == Never {
    public var body: Self.Body {
        neverScene("\(Self.self)")
    }
}

extension Never: SomeScene {}
extension Never: Scene {}

/// Calls `fatalError` with an explanation that a given `type` is a primitive `Scene`
public func neverScene(_ type: String) -> Never {
    fatalError("\(type) is a primitive `Scene`, you're not supposed to access its `body`.")
}

extension Scene {
    internal func environment<V>(
        _ keyPath: WritableKeyPath<EnvironmentValues, V>,
        _ value: V
    ) -> ModifiedContent<Self, _EnvironmentKeyWritingModifier<V>> {
        modifier(_EnvironmentKeyWritingModifier(keyPath: keyPath, value: value))
    }
}

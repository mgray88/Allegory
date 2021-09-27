//
//  SceneDelegate.swift
//  TOCUIKit
//
//  Created by Mike on 8/22/21.
//

import UIKit

@available(iOS 13.0, *)
internal final class AppSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print(#function)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: Text("Hello World!"))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print(#function)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print(#function)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print(#function)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(#function)
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        print(#function)
        return nil
    }

    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        print(#function)
    }

    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        print(#function)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print(#function)
    }

    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print(#function)
    }

    func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
        print(#function)
    }
}

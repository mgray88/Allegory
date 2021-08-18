//
// Created by Mike on 8/15/21.
//

import UIKit

extension App {
    public static func _launch(_ app: Self, _ rootEnvironment: EnvironmentValues) {
        AppDelegate.main()
    }
}

open class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    open func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        self.window = window
        return true
    }

    public func applicationWillResignActive(_ application: UIApplication) {
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
    }

    public func applicationWillTerminate(_ application: UIApplication) {
    }
}

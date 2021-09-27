//
// Created by Mike on 8/15/21.
//

import CloudKit
import Intents
import UIKit.UIApplication

internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    internal weak var consumerDelegate: UIApplicationDelegate?

    internal var window: UIWindow? = nil

    internal override init() {
        print(#function)
        super.init()
    }

    internal func applicationDidFinishLaunching(_ application: UIApplication) {
        print(#function)
        consumerDelegate?.applicationDidFinishLaunching?(application)
    }

    internal func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print(#function)
        return consumerDelegate?
            .application?(
                application,
                willFinishLaunchingWithOptions: launchOptions
            ) ?? true
    }

    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print(#function)

        // TODO: This is fragile
        guard Double(UIDevice.current.systemVersion)! < 13 else {
            return consumerDelegate?
                .application?(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                ) ?? true
        }

        guard let delegate = consumerDelegate else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UIHostingController(rootView: Text("Hello World!"))
            window?.makeKeyAndVisible()
            return true
        }

        if let result = delegate
            .application?(
                application,
                didFinishLaunchingWithOptions: launchOptions
            ),
           result == false {
            return false
        }

        window = delegate.window ?? UIWindow(frame: UIScreen.main.bounds)
        // TODO
        return true
    }

    internal func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
        consumerDelegate?.applicationDidBecomeActive?(application)
    }

    internal func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
        consumerDelegate?.applicationWillResignActive?(application)
    }

    internal func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        print(#function)
        return consumerDelegate?.application?(application, handleOpen: url) ?? false
    }

    internal func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        print(#function)
        return consumerDelegate?.application?(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        ) ?? false
    }

    internal func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        print(#function)
        return consumerDelegate?.application?(app, open: url, options: options) ?? false
    }

    internal func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print(#function)
        consumerDelegate?.applicationDidReceiveMemoryWarning?(application)
    }

    internal func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        consumerDelegate?.applicationWillTerminate?(application)
    }

    internal func applicationSignificantTimeChange(_ application: UIApplication) {
        print(#function)
        consumerDelegate?.applicationSignificantTimeChange?(application)
    }

    internal func application(
        _ application: UIApplication,
        willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation,
        duration: TimeInterval
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            willChangeStatusBarOrientation: newStatusBarOrientation,
            duration: duration
        )
    }

    internal func application(
        _ application: UIApplication,
        didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            didChangeStatusBarOrientation: oldStatusBarOrientation
        )
    }

    internal func application(
        _ application: UIApplication,
        willChangeStatusBarFrame newStatusBarFrame: CoreGraphics.CGRect
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            willChangeStatusBarFrame: newStatusBarFrame
        )
    }

    internal func application(
        _ application: UIApplication,
        didChangeStatusBarFrame oldStatusBarFrame: CoreGraphics.CGRect
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            didChangeStatusBarFrame: oldStatusBarFrame
        )
    }

    internal func application(
        _ application: UIApplication,
        didRegister notificationSettings: UIUserNotificationSettings
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            didRegister: notificationSettings
        )
    }

    internal func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
        )
    }

    internal func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print(#function)
        consumerDelegate?.application?(
            application,
            didFailToRegisterForRemoteNotificationsWithError: error
        )
    }

    internal func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(#function)
    }

    internal func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        for notification: UILocalNotification,
        completionHandler: @escaping () -> Void
    ) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        forRemoteNotification userInfo: [AnyHashable: Any],
        withResponseInfo responseInfo: [AnyHashable: Any],
        completionHandler: @escaping () -> Void
    ) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        forRemoteNotification userInfo: [AnyHashable: Any],
        completionHandler: @escaping () -> Void
    ) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        handleActionWithIdentifier identifier: String?,
        for notification: UILocalNotification,
        withResponseInfo responseInfo: [AnyHashable: Any],
        completionHandler: @escaping () -> Void
    ) {
    }

    internal func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
    }

    internal func application(
        _ application: UIApplication,
        handleEventsForBackgroundURLSession identifier: String,
        completionHandler: @escaping () -> Void
    ) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        handleWatchKitExtensionRequest userInfo: [AnyHashable: Any]?,
        reply: @escaping ([AnyHashable: Any]?) -> Void
    ) {
        print(#function)
    }

    internal func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
    }

    internal func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        handle intent: INIntent,
        completionHandler: @escaping (INIntentResponse) -> Void
    ) {
        print(#function)
    }

    internal func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }

    internal func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }

    internal func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        print(#function)
    }

    internal func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        print(#function)
        return .all
    }

    internal func application(
        _ application: UIApplication,
        shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier
    ) -> Bool {
        print(#function)
        return false
    }

    internal func application(
        _ application: UIApplication,
        viewControllerWithRestorationIdentifierPath identifierComponents: [String],
        coder: NSCoder
    ) -> UIViewController? {
        print(#function)
        return nil
    }

    internal func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        print(#function)
        return false
    }

    internal func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        print(#function)
        return false
    }

    internal func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        print(#function)
    }

    internal func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        print(#function)
    }

    internal func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        print(#function)
        return false
    }

    internal func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        print(#function)
        return false
    }

    internal func application(
        _ application: UIApplication,
        willContinueUserActivityWithType userActivityType: String
    ) -> Bool {
        print(#function)
        return false
    }

    internal func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        print(#function)
        return false
    }

    internal func application(
        _ application: UIApplication,
        didFailToContinueUserActivityWithType userActivityType: String,
        error: Error
    ) {
        print(#function)
    }

    internal func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        print(#function)
    }

    internal func application(
        _ application: UIApplication,
        userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata
    ) {
        print(#function)
    }

    @available(iOS 13.0, *)
    internal func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        print(#function)
        let config = consumerDelegate?
            .application?(
                application,
                configurationForConnecting: connectingSceneSession,
                options: options
            ) ?? connectingSceneSession.configuration
        if let consumerDelegateClass = config.delegateClass {

        }
        config.delegateClass = AppSceneDelegate.self
        return config
    }

    @available(iOS 13.0, *)
    internal func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print(#function)
    }
}

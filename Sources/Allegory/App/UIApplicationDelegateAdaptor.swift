//
// Created by Mike on 8/15/21.
//

import ObjectiveC.NSObject
import UIKit.UIApplication

protocol UIApplicationDelegateProperty: DynamicProperty {
    var delegate: UIApplicationDelegate { get }
}

/// A property wrapper that is used in `App` to provide a delegate from UIKit.
@propertyWrapper
public struct UIApplicationDelegateAdaptor<DelegateType> : DynamicProperty
    where DelegateType: ObjectiveC.NSObject,
    DelegateType: UIKit.UIApplicationDelegate {

    /// The underlying delegate.
    public let wrappedValue: DelegateType

    /// Creates an `UIApplicationDelegateAdaptor` using a UIKit Application
    /// Delegate.
    ///
    /// The framework will initialize the provided delegate and manage its
    /// lifetime, calling out to it when appropriate after performing its
    /// own work.
    ///
    /// - Parameter delegate: the type of `UIApplicationDelegate` to use.
    public init(_ delegateType: DelegateType.Type = DelegateType.self) {
        wrappedValue = delegateType.init()
    }
}

extension UIApplicationDelegateAdaptor where DelegateType: RxObservableObject {
    /// Creates an `UIApplicationDelegateAdaptor` using a UIKit
    /// Application Delegate.
    ///
    /// The framework will initialize the provided delegate and manage its
    /// lifetime, calling out to it when appropriate after performing its
    /// own work.
    ///
    /// - Parameter delegate: the type of `UIApplicationDelegate` to use.
    /// - Note: the instantiated delegate will be placed in the Environment
    ///   and may be accessed by using the `@EnvironmentObject` property wrapper
    ///   in the view hierarchy.
    public init(_ delegateType: DelegateType.Type = DelegateType.self) {
        wrappedValue = delegateType.init()
    }

    public var projectedValue: RxObservedObject<DelegateType>.Wrapper {
        RxObservedObject(wrappedValue: wrappedValue).projectedValue
    }
}

extension UIApplicationDelegateAdaptor: UIApplicationDelegateProperty {
    var delegate: UIApplicationDelegate { wrappedValue }
}

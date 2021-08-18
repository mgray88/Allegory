//
// Created by Mike on 8/15/21.
//

import ObjectiveC.NSObject
import UIKit.UIApplication

@propertyWrapper
public struct UIApplicationDelegateAdaptor<DelegateType>: DynamicProperty
    where DelegateType: ObjectiveC.NSObject, DelegateType: UIKit.UIApplicationDelegate {

    public let wrappedValue: DelegateType

    public init(_ delegateType: DelegateType.Type = DelegateType.self) {
        wrappedValue = delegateType.init()
    }
}

extension UIApplicationDelegateAdaptor where DelegateType: RxObservableObject {
    public init(_ delegateType: DelegateType.Type = DelegateType.self) {
        wrappedValue = delegateType.init()
    }

    public var projectedValue: RxObservedObject<DelegateType>.Wrapper {
        RxObservedObject(wrappedValue: wrappedValue).projectedValue
    }
}

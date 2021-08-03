//
// Created by Mike on 7/31/21.
//

import RxSwift


/// A type of object with a publisher that emits before the object has changed.
///
/// By default an ``ObservableObject`` will synthesize an ``objectWillChange``
/// publisher that emits before any of its `@Published` properties changes:
///
/// ```swift
/// class Contact: ObservableObject {
///     @Published var name: String
///     @Published var age: Int
///
///     init(name: String, age: Int) {
///         self.name = name
///         self.age = age
///     }
///
///     func haveBirthday() -> Int {
///         age += 1
///         return age
///     }
/// }
///
/// let john = Contact(name: "John Appleseed", age: 24)
/// disposable = john.objectWillChange
///     .subscribe(onNext: { _ in
///         print("\(john.age) will change")
///     })
/// print(john.haveBirthday())
/// // Prints "24 will change"
/// // Prints "25"
/// ```
public protocol ObservableObject: AnyObject {
    /// The type of publisher that emits before the object has changed.
    associatedtype ObjectWillChangeObservable: InfallibleType = Infallible<Void>
        where Self.ObjectWillChangeObservable.Element == Void

    /// A publisher that emits before the object has changed.
    var objectWillChange: Self.ObjectWillChangeObservable { get }
}

extension ObservableObject where Self.ObjectWillChangeObservable == Infallible<Void> {
    public var objectWillChange: ObjectWillChangeObservable {
        var willChanges: [Infallible<Void>] = []
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if var publishedProperty = child.value as? _MutablePropertyWrapper {
                willChanges.append(publishedProperty.willChange)
            }
        }
        return Infallible.merge(willChanges)
    }
}

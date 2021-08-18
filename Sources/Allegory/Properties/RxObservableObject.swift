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
public protocol RxObservableObject: AnyObject {
    /// The type of publisher that emits before the object has changed.
    associatedtype ObjectWillChangeObservable: InfallibleType = Infallible<Void>
        where Self.ObjectWillChangeObservable.Element == Void

    /// A publisher that emits before the object has changed.
    var objectWillChange: Self.ObjectWillChangeObservable { get }
}

extension RxObservableObject where Self.ObjectWillChangeObservable == Infallible<Void> {
    public var objectWillChange: ObjectWillChangeObservable {
        var installedObservable: PublishSubject<Void>?
        let mirror = Mirror(reflecting: self)
        for (_, property) in mirror.children {
            guard let property = property as? _ObservableObjectProperty
            else {
                continue
            }

            // Now we know that the field is @Published.
            if let alreadyInstalledObservable = property.objectWillChange {
                installedObservable = alreadyInstalledObservable
                // Don't visit other fields, as all @Published fields
                // already have a publisher installed.
                break
            }

            // Okay, this field doesn't have a publisher installed.
            // This means that other fields don't have it either
            // (because we install it only once and fields can't be added at runtime).
            var lazilyCreatedObservable: PublishSubject<Void> {
                if let observable = installedObservable {
                    return observable
                }
                let observable = PublishSubject<Void>()
                installedObservable = observable
                return observable
            }

            property.objectWillChange = lazilyCreatedObservable

            // continue visiting other fields.
        }
        // TODO: Visit superclass fields?

        return installedObservable?.asInfallible(onErrorFallbackTo: .never()) ??
            ObjectWillChangeObservable.never()
    }
}

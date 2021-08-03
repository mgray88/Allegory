//
// Created by Mike on 7/29/21.
//

import RxSwift

@propertyWrapper
public struct Published<Value> {

    private var value: Value
    private var publisher: Publisher?
    private let willChangeSubject = PublishSubject<Void>()

    public init(wrappedValue: Value) {
        value = wrappedValue
    }

    /// A publisher for properties used with the `@Published` attribute.
    public struct Publisher: InfallibleType {
        public typealias Element = Value

        fileprivate let didChangeSubject: BehaviorSubject<Value>

        public func asObservable() -> Observable<Value> {
            didChangeSubject.asObservable()
        }

        fileprivate init(_ output: Element) {
            self.didChangeSubject = BehaviorSubject(value: output)
        }
    }

    public var wrappedValue: Value {
        get { self.value }
        set {
            self.willChangeSubject.onNext(())
            self.value = newValue
            self.publisher?.didChangeSubject.onNext(newValue)
        }
    }

    public var projectedValue: Publisher {
        mutating get {
            if let publisher = publisher {
                return publisher
            }
            let publisher = Publisher(value)
            self.publisher = publisher
            return publisher
        }
    }
}

protocol _MutablePropertyWrapper {
    var willChange: Infallible<Void> { mutating get }
}

extension Published: _MutablePropertyWrapper {

    var willChange: Infallible<Void> {
        mutating get {
            willChangeSubject.asInfallible(onErrorJustReturn: ())
        }
    }
}

//
// Created by Mike on 7/29/21.
//

import RxSwift

/// A type that publishes a property marked with an attribute.
///
/// Publishing a property with the `@Published` attribute creates a publisher of
/// this type. You access the publisher with the `$` operator, as shown here:
///
///     class Weather {
///         @Published var temperature: Double
///         init(temperature: Double) {
///             self.temperature = temperature
///         }
///     }
///
///     let weather = Weather(temperature: 20)
///     cancellable = weather.$temperature
///         .sink() {
///             print ("Temperature now: \($0)")
///         }
///     weather.temperature = 25
///
///     // Prints:
///     // Temperature now: 20.0
///     // Temperature now: 25.0
///
/// When the property changes, publishing occurs in the property's `willSet` block,
/// meaning subscribers receive the new value before it's actually set on the property.
/// In the above example, the second time the sink executes its closure, it receives
/// the parameter value `25`. However, if the closure evaluated `weather.temperature`,
/// the value returned would be `20`.
///
/// > Important: The `@Published` attribute is class constrained. Use it with properties
/// of classes, not with non-class types like structures.
@propertyWrapper
public struct RxPublished<Value> {

    /// A publisher for properties used with the `@Published` attribute.
    public struct Publisher: ObservableType {
        public typealias Element = Value

        fileprivate let subject: RxPublishedSubject<Value>

        public func subscribe<Observer>(
            _ observer: Observer
        ) -> Disposable where Observer: ObserverType, Value == Observer.Element {
            subject.subscribe(observer)
        }

        public func asObservable() -> Observable<Value> {
            subject.asObservable()
        }

        fileprivate init(_ output: Element) {
            subject = RxPublishedSubject(value: output)
        }
    }

    private enum Storage {
        case value(Value)
        case publisher(Publisher)
    }

    @propertyWrapper
    final private class Box {
        var wrappedValue: Storage

        init(wrappedValue: Storage) {
            self.wrappedValue = wrappedValue
        }
    }

    @Box private var storage: Storage

    /// Creates the published instance with an initial wrapped value.
    ///
    /// Don't use this initializer directly. Instead, create a property with
    /// the `@Published` attribute, as shown here:
    ///
    ///     @Published var lastUpdated: Date = Date()
    ///
    /// - Parameter wrappedValue: The publisher's initial value.
    public init(initialValue: Value) {
        self.init(wrappedValue: initialValue)
    }

    /// Creates the published instance with an initial value.
    ///
    /// Don't use this initializer directly. Instead, create a property with
    /// the `@Published` attribute, as shown here:
    ///
    ///     @Published var lastUpdated: Date = Date()
    ///
    /// - Parameter initialValue: The publisher's initial value.
    public init(wrappedValue: Value) {
        _storage = Box(wrappedValue: .value(wrappedValue))
    }

    /// The property for which this instance exposes a publisher.
    ///
    /// The `projectedValue` is the property accessed with the `$` operator.
    public var projectedValue: Publisher {
        mutating get {
            getPublisher()
        }
        set { // swiftlint:disable:this unused_setter_value
            switch storage {
            case .value(let value):
                storage = .publisher(Publisher(value))
            case .publisher:
                break
            }
        }
    }

    /// Note: This method can mutate `storage`
    internal func getPublisher() -> Publisher {
        switch storage {
        case .value(let value):
            let publisher = Publisher(value)
            storage = .publisher(publisher)
            return publisher
        case .publisher(let publisher):
            return publisher
        }
    }

    @available(*, unavailable,
               message: "@Published is only available on properties of classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() } // swiftlint:disable:this unused_setter_value
    }

    public static subscript<EnclosingSelf: AnyObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, RxPublished<Value>>
    ) -> Value {
        get {
            switch object[keyPath: storageKeyPath].storage {
            case .value(let value):
                return value
            case .publisher(let publisher):
                return publisher.subject.value
            }
        }
        set {
            switch object[keyPath: storageKeyPath].storage {
            case .value:
                object[keyPath: storageKeyPath].storage = .publisher(Publisher(newValue))
            case .publisher(let publisher):
                publisher.subject.accept(newValue)
            }
        }
    }
}

protocol _ObservableObjectProperty {
    var objectWillChange: PublishSubject<Void>? { get nonmutating set }
}

extension RxPublished: _ObservableObjectProperty {

    var objectWillChange: PublishSubject<Void>? {
        get {
            switch storage {
            case .value:
                return nil
            case .publisher(let publisher):
                return publisher.subject.objectWillChange
            }
        }
        nonmutating set {
            getPublisher().subject.objectWillChange = newValue
        }
    }
}

extension ObservableConvertibleType {
    public func bind(to publisher: RxPublished<Element>.Publisher) -> Disposable {
        asObservable().subscribe(RxPublishedObserver(publisher.subject))
    }
}

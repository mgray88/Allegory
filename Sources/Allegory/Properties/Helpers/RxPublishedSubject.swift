//
// Created by Mike on 8/13/21.
//

import RxSwift

typealias RecursiveLock = NSRecursiveLock

protocol Lock {
    func lock()
    func unlock()
}

// https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20151214/000321.html
typealias SpinLock = RecursiveLock

extension RecursiveLock : Lock {
    @inline(__always)
    final func performLocked<T>(_ action: () -> T) -> T {
        self.lock(); defer { self.unlock() }
        return action()
    }
}

internal final class RxPublishedSubject<Element>: SubjectType {
    private let subject: BehaviorSubject<Element>

    private let lock = RecursiveLock()

    private var changePublisher: PublishSubject<()>?

    /// Accepts `event` and emits it to subscribers
    internal func accept(_ event: Element) {
        lock.lock()
        defer { lock.unlock() }
        changePublisher?.onNext(())
        self.subject.onNext(event)
    }

    /// Current value of behavior subject
    internal var value: Element {
        get {
            lock.lock()
            defer { lock.unlock() }
            return try! self.subject.value()
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            accept(newValue)
        }
    }

    internal var objectWillChange: PublishSubject<Void>? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return changePublisher
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            changePublisher = newValue
        }
    }

    /// Initializes behavior relay with initial value.
    internal init(value: Element) {
        self.subject = BehaviorSubject(value: value)
    }

    /// Subscribes observer
    internal func subscribe<Observer: ObserverType>(
        _ observer: Observer
    ) -> Disposable where Observer.Element == Element {
        self.subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    internal func asObservable() -> Observable<Element> {
        self.subject.asObservable()
    }

    internal func asObserver() -> BehaviorSubject<Element> {
        self.subject
    }
}

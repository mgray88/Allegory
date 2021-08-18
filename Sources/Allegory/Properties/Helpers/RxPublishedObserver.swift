//
// Created by Mike on 8/13/21.
//

import RxSwift

internal struct RxPublishedObserver<Element>: ObserverType {

    private weak var subject: RxPublishedSubject<Element>?

    internal init(_ subject: RxPublishedSubject<Element>) {
        self.subject = subject
    }

    func on(_ event: Event<Element>) {
        switch event {
        case let .next(element):
            subject?.accept(element)

        default:
            break
        }
    }
}

//
// Created by Mike on 8/15/21.
//

@usableFromInline
internal struct _TupleScene<T>: Scene {
    @usableFromInline
    internal var value: T

    @usableFromInline
    internal var body: SomeScene {
        fatalError()
    }

    @usableFromInline
    internal init(_ value: T) {
        self.value = value
    }

    @usableFromInline
    internal typealias Body = Never
}

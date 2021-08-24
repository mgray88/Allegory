//
// Created by Mike on 8/24/21.
//

@usableFromInline
internal class AnyLocationBase {}

@usableFromInline
internal class AnyLocation<Value>: AnyLocationBase {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
}

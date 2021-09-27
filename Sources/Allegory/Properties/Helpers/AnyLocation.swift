//
// Created by Mike on 8/24/21.
//

@usableFromInline
internal class AnyLocationBase {}

@usableFromInline
internal class AnyLocation<Value>: AnyLocationBase {
    var value: Value
    var binding: Binding<Value> = Binding(get: { fatalError() }, set: { _ in fatalError() })

    init(_ value: Value) {
        self.value = value
        super.init()

        self.binding = Binding(get: { [unowned self] in
            self.value
        }, set: { [unowned self] in
            self.value = $0
        })
    }
}

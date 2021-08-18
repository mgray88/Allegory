//
// Created by Mike on 7/29/21.
//

public struct _ConditionalContent<TrueContent: View, FalseContent: View>: View {

    public typealias Body = Swift.Never

    @usableFromInline
    internal enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    @usableFromInline
    internal let storage: Storage

    @usableFromInline
    internal init(storage: Storage) {
        self.storage = storage
    }
}

//
// Created by Mike on 7/29/21.
//

public struct ConditionalContent<TrueContent: View, FalseContent: View>: View {

    public typealias Body = Swift.Never

    public enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    public let storage: Storage

    public init(_ trueContent: TrueContent) {
        storage = .trueContent(trueContent)
    }

    public init(_ falseContent: FalseContent) {
        storage = .falseContent(falseContent)
    }
}

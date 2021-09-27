//
// Created by Mike on 9/23/21.
//

public struct Window<Content>: Scene where Content: View {
    public let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

class WindowNode {

}

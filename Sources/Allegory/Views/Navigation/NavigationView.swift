//
// Created by Mike on 8/15/21.
//

public struct NavigationView<Content>: View where Content: View {
//    let content: SomeView

    @StateObject var context = NavigationContext()

    public init(@ViewBuilder content: () -> Content) {
//        self.content = content().environmentObject(context)
    }
}

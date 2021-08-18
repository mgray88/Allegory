//
// Created by Mike on 8/9/21.
//

extension ViewModifiers {
    public struct _TabItem: ViewModifier {
    }
}

extension View {

    /// Sets the tab bar item associated with this view.
    ///
    /// Use `tabItem(_:)` to configure a view as a tab bar item in a
    /// ``TabView``. The example below adds two views as tabs in a ``TabView``:
    ///
    ///     struct View1: View {
    ///         var body: some View {
    ///             Text("View 1")
    ///         }
    ///     }
    ///
    ///     struct View2: View {
    ///         var body: some View {
    ///             Text("View 2")
    ///         }
    ///     }
    ///
    ///     struct TabItem: View {
    ///         var body: some View {
    ///             TabView {
    ///                 View1()
    ///                     .tabItem {
    ///                         Label("Menu", systemImage: "list.dash")
    ///                     }
    ///
    ///                 View2()
    ///                     .tabItem {
    ///                         Label("Order", systemImage: "square.and.pencil")
    ///                     }
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter label: The tab bar item to associate with this view.
    public func tabItem<V>(
        @ViewBuilder _ label: () -> V
    ) -> ModifiedContent<Self, ViewModifiers._TabItem> where V: View {
        TODO()
    }
}

//
// Created by Mike on 8/9/21.
//

import UIKit

/// A view that switches between multiple child views using interactive user
/// interface elements.
///
/// To create a user interface with tabs, place views in a `TabView` and apply
/// the ``View/tabItem(_:)`` modifier to the contents of each tab. On iOS, you
/// can also use the ``View/badge(_:)`` modifier to assign a badge to each of
/// the tabs. The following creates a tab view with three tabs, the first of
/// which has a badge:
///
///     TabView {
///         Text("The First Tab")
///             .badge(10)
///             .tabItem {
///                 Image(systemName: "1.square.fill")
///                 Text("First")
///             }
///         Text("Another Tab")
///             .tabItem {
///                 Image(systemName: "2.square.fill")
///                 Text("Second")
///             }
///         Text("The Last Tab")
///             .tabItem {
///                 Image(systemName: "3.square.fill")
///                 Text("Third")
///             }
///     }
///     .font(.headline)
///
/// Tab views only support tab items of type ``Text``, ``Image``, or an image
/// followed by text. Passing any other type of view results in a visible but
/// empty tab item.
public struct TabView<SelectionValue, Content>: View
    where SelectionValue: Hashable, Content: View {

    /// Creates an instance that selects from content associated with
    /// `Selection` values.
    public init(
        selection: Binding<SelectionValue>?,
        @ViewBuilder content: () -> Content
    ) {
    }
}

extension TabView where SelectionValue == Int {

    public init(@ViewBuilder content: () -> Content) {
        self.init(selection: nil, content: content)
    }
}

extension TabView: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "TabView"
        }

        let tabBar = UITabBarController()

        func update(view: TabView<SelectionValue, Content>, context: Context) {
        }

        func size(
            fitting proposedSize: ProposedSize,
            pass: LayoutPass
        ) -> CGSize {
            proposedSize.orMax
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            guard let parentViewController = container.viewController
            else { return }

            parentViewController.add(tabBar)
        }
    }

    func resolve(
        context: Context,
        cachedNode: SomeUIKitNode?
    ) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

//public class UIKitTabView<Tabs: RandomAccessCollection>: UITabBarController, UITabBarControllerDelegate
//    where Tabs == LazyMapSequence<_VariadicView_Children, _TabItem> {
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.delegate = self
//        let orders = UIHostingController(rootView: Text("Orders"))
//        orders.tabBarItem = .init(title: "Orders", image: nil, tag: 0)
//        let zStack = UIHostingController(rootView: Text("ZStack"))
//        zStack.tabBarItem = .init(title: "ZStack", image: nil, tag: 1)
//        viewControllers = [
//            orders,
//            zStack
//        ]
//        tabBar.barTintColor = .white
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        super.tabBar(tabBar, didSelect: item)
//    }
//}
//
//extension UIKitTabView: _VariadicView_UnaryViewRoot {}

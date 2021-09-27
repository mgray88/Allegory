//
// Created by Mike on 8/9/21.
//

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
    ) -> ModifiedContent<Self, _TabItem> where V: View {
        modifier(_TabItem(label()))
    }
}

// SwiftUI.TabView<Int, SwiftUI.ModifiedContent<SwiftUI.ModifiedContent<SwiftUI.Text, SwiftUI.PlatformItemTraitWriter<SwiftUI.LabelPlatformItemListFlags, SwiftUI.ModifiedContent<SwiftUI.ModifiedContent<SwiftUI.ModifiedContent<SwiftUI.Text, SwiftUI._EnvironmentKeyTransformModifier<SwiftUI.SymbolVariants>>, SwiftUI.AccessibilityContainerModifier>, SwiftUI.MergePlatformItemsModifier>, SwiftUI.TabItem.TraitKey>>, SwiftUI._TraitWritingModifier<SwiftUI.TagValueTraitKey<String>>>>
//SwiftUI.ModifiedContent<
//    SwiftUI.ModifiedContent<
//        SwiftUI.Text,
//        SwiftUI.PlatformItemTraitWriter<
//            SwiftUI.LabelPlatformItemListFlags,
//            SwiftUI.ModifiedContent<
//                SwiftUI.ModifiedContent<
//                    SwiftUI.ModifiedContent<
//                        SwiftUI.Text,
//                        SwiftUI._EnvironmentKeyTransformModifier<
//                            SwiftUI.SymbolVariants
//                        >
//                    >,
//                    SwiftUI.AccessibilityContainerModifier
//                >,
//                SwiftUI.MergePlatformItemsModifier
//            >,
//            SwiftUI.TabItem.TraitKey
//        >
//    >,
//    SwiftUI._TraitWritingModifier<
//        SwiftUI.TagValueTraitKey<
//            Int
//        >
//    >
//>

public struct _TabItem: ViewModifier {
    init<V: View>(_ label: V) {
    }

    public struct TraitKey: _PlatformItemTraitKey {

    }
}

public protocol _PlatformItemTraitKey {}

public struct _PlatformItemTraitWriter<Tags, Content, Trait>: ViewModifier {

}

extension _TabItem: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "_TabItem"
        }

        func update(viewModifier: _TabItem, context: inout Context) {

        }

        func render(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {
//            container.viewController?.tabBarItem = .init(
//                title: <#T##String?#>,
//                image: <#T##UIImage?#>,
//                tag: <#T##Int#>
//            )
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

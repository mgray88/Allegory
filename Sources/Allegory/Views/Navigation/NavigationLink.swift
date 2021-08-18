////
//// Created by Mike on 8/15/21.
////
//
//final class NavigationLinkDestination {
//    let view: SomeView
//    init<V: View>(_ destination: V) {
//        view = destination
//    }
//}
//
//public struct NavigationLink<Label, Destination>: _PrimitiveView
//    where Label: View, Destination: View {
//
//    @State var destination: NavigationLinkDestination
//    let label: Label
//
//    @EnvironmentObject var navigationContext: NavigationContext
//
//    public init(
//        @ViewBuilder destination: () -> Destination,
//        @ViewBuilder label: () -> Label
//    ) {
//        self.init(destination: destination(), label: label)
//    }
//
//    public init(
//        isActive: Binding<Swift.Bool>,
//        @ViewBuilder destination: () -> Destination,
//        @ViewBuilder label: () -> Label
//    ) {
//        self.init(destination: destination(), isActive: isActive, label: label)
//    }
//
//    public init<V>(
//        tag: V,
//        selection: Binding<V?>,
//        @ViewBuilder destination: () -> Destination,
//        @ViewBuilder label: () -> Label
//    ) where V: Hashable {
//        self.init(
//            destination: destination(),
//            tag: tag,
//            selection: selection,
//            label: label)
//    }
//
//    @available(iOS, introduced: 10.0, deprecated: 100000.0, message: "Pass a closure as the destination")
//    public init(destination: Destination, @ViewBuilder label: () -> Label) {
//        self.label = label()
//        self.destination = .init(destination)
////        _destination = State(wrappedValue: NavigationLinkDestination(destination))
////        self.label = label()
//    }
//
//    @available(iOS, introduced: 10.0, deprecated: 100000.0, renamed: "NavigationLink(isActive:destination:label:)")
//    public init(
//        destination: Destination,
//        isActive: Binding<Bool>,
//        @ViewBuilder label: () -> Label
//    ) {}
//
//    @available(iOS, introduced: 10.0, deprecated: 100000.0, renamed: "NavigationLink(tag:selection:destination:label:)")
//    public init<V>(
//        destination: Destination,
//        tag: V,
//        selection: Binding<V?>,
//        @ViewBuilder label: () -> Label
//    ) where V: Hashable {}
//}
//
//extension NavigationLink where Label == Text {
//    @_disfavoredOverload
//    public init<S>(_ title: S, @ViewBuilder destination: () -> Destination) where S : Swift.StringProtocol {
//        self.init(title, destination: destination())
//    }
//
//    @_disfavoredOverload
//    public init<S>(_ title: S, isActive: Binding<Swift.Bool>, @ViewBuilder destination: () -> Destination) where S : Swift.StringProtocol {
//        self.init(title, destination: destination(), isActive: isActive)
//    }
//
//    @_disfavoredOverload
//    public init<S, V>(_ title: S, tag: V, selection: Binding<V?>, @ViewBuilder destination: () -> Destination) where S : Swift.StringProtocol, V : Swift.Hashable {
//        self.init(
//            title,
//            destination: destination(),
//            tag: tag, selection: selection)
//    }
//
//    @available(iOS, introduced: 10.0, deprecated: 100000.0, message: "Pass a closure as the destination")
//    @_disfavoredOverload
//    public init<S>(_ title: S, destination: Destination) where S : Swift.StringProtocol {}
//
//    @available(iOS, introduced: 10.0, deprecated: 100000.0, renamed: "NavigationLink(_:isActive:destination:)")
//    @_disfavoredOverload
//    public init<S>(_ title: S, destination: Destination, isActive: Binding<Swift.Bool>) where S : Swift.StringProtocol {}
//
//    @available(iOS, introduced: 10.0, deprecated: 100000.0, renamed: "NavigationLink(_:tag:selection:destination:)")
//    @_disfavoredOverload
//    public init<S, V>(_ title: S, destination: Destination, tag: V, selection: Binding<V?>) where S : Swift.StringProtocol, V : Swift.Hashable {}
//}

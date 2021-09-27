////
//// Created by Mike on 8/15/21.
////

final class NavigationLinkDestination {
    let view: SomeView
    init<V: View>(_ destination: V) {
        view = destination
    }
}

public struct NavigationLink<Label, Destination>: View
    where Label: View, Destination: View {

//    @State var destination: NavigationLinkDestination
//    let label: Label
//
//    @EnvironmentObject var navigationContext: NavigationContext

    public init(
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.init(destination: destination(), label: label)
    }

    public init(
        isActive: Binding<Swift.Bool>,
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.init(destination: destination(), isActive: isActive, label: label)
    }

    public init<V>(
        tag: V,
        selection: Binding<V?>,
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) where V: Hashable {
        self.init(
            destination: destination(),
            tag: tag,
            selection: selection,
            label: label)
    }

    internal init(destination: Destination, @ViewBuilder label: () -> Label) {
//        self.label = label()
//        self.destination = .init(destination)
//        _destination = State(wrappedValue: NavigationLinkDestination(destination))
//        self.label = label()
    }

    internal init(
        destination: Destination,
        isActive: Binding<Bool>,
        @ViewBuilder label: () -> Label
    ) {}

    internal init<V>(
        destination: Destination,
        tag: V,
        selection: Binding<V?>,
        @ViewBuilder label: () -> Label
    ) where V: Hashable {}
}

extension NavigationLink where Label == Text {
    @_disfavoredOverload
    public init<S>(_ title: S, @ViewBuilder destination: () -> Destination) where S : Swift.StringProtocol {
        self.init(title, destination: destination())
    }

    @_disfavoredOverload
    public init<S>(_ title: S, isActive: Binding<Swift.Bool>, @ViewBuilder destination: () -> Destination) where S : Swift.StringProtocol {
        self.init(title, destination: destination(), isActive: isActive)
    }

    @_disfavoredOverload
    public init<S, V>(_ title: S, tag: V, selection: Binding<V?>, @ViewBuilder destination: () -> Destination) where S : Swift.StringProtocol, V : Swift.Hashable {
        self.init(
            title,
            destination: destination(),
            tag: tag, selection: selection)
    }

    internal init<S>(_ title: S, destination: Destination) where S : Swift.StringProtocol {}

    internal init<S>(_ title: S, destination: Destination, isActive: Binding<Swift.Bool>) where S : Swift.StringProtocol {}

    internal init<S, V>(_ title: S, destination: Destination, tag: V, selection: Binding<V?>) where S : Swift.StringProtocol, V : Swift.Hashable {}
}

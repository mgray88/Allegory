//
// Created by Mike on 8/5/21.
//

extension View {
    /// Presents an alert with a message using the given data to produce the
    /// alert's content and a string variable as a title.
    ///
    /// For the alert to appear, both `isPresented` must be `true` and
    /// `data` must not be `nil`. The data should not change after the
    /// presentation occurs. Any changes that you make after the presentation
    /// occurs are ignored.
    ///
    /// Use this method when you need to populate the fields of an alert with
    /// content from a data source. The example below shows a custom data
    /// source, `SaveDetails`, that provides data to populate the alert:
    ///
    ///     struct SaveDetails: Identifiable {
    ///         let name: String
    ///         let error: String
    ///     }
    ///     struct SaveView: View {
    ///         var title: String
    ///         @State var didError = false
    ///         @State var details: SaveDetails?
    ///         var body: some View {
    ///             Button("Save File") {
    ///                 details = model.save(didError: $didError)
    ///             }
    ///             .alert(
    ///                 title, isPresented: $didError, presenting: details
    ///             ) { detail in
    ///                 Button(role: .destructive) {
    ///                     // Handle delete action.
    ///                 } label: {
    ///                     Text("""
    ///                     Delete \(detail.name)
    ///                     """)
    ///                 }
    ///                 Button("Retry") {
    ///                     // handle retry action.
    ///                 }
    ///             } message: { detail in
    ///                 Text(detail.error)
    ///             }
    ///         }
    ///     }
    ///
    /// All actions in an alert dismiss the alert after the action runs.
    /// The default button is shown with greater prominence.  You can
    /// influence the default button by assigning it the
    /// ``KeyboardShortcut/defaultAction`` keyboard shortcut.
    ///
    /// The system may reorder the buttons based on their role and prominence.
    ///
    /// If no actions are present, the system includes a standard "OK"
    /// action. No default cancel action is provided. If you want to show a
    /// cancel action, use a button with a role of ``ButtonRole/cancel``.
    ///
    /// On iOS, tvOS, and watchOS, alerts only support controls with labels that
    /// are ``Text``. Passing any other type of view results in the content
    /// being omitted.
    ///
    /// Only unstyled text is supported for the message.
    ///
    /// - Parameters:
    ///   - title: A text string used as the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to
    ///     present the alert. When the user presses or taps one of the alert's
    ///     actions, the system sets this value to `false` and dismisses.
    ///   - data: An optional source of truth for the alert. The system passes
    ///     the contents to the modifier's closures. You use this data to
    ///     populate the fields of an alert that you create that the system
    ///     displays to the user.
    ///   - actions: A ``ViewBuilder`` returning the alert's actions given the
    ///     currently available data.
    ///   - message: A ``ViewBuilder`` returning the message for the alert given
    ///     the currently available data.
    @_spi(Incomplete)
    public func alert<S, A, M, T>(
        _ title: S,
        isPresented: Binding<Bool>,
        presenting data: T?,
        actions: (T) -> A,
        message: (T) -> M
    ) -> ModifiedContent<Self, AlertModifier<A, M>>
        where S: StringProtocol, A: View, M: View {
        modifier(.init(isPresented: Binding(projectedValue: isPresented)))
    }
}
//SwiftUI.AlertModifier<SwiftUI.ModifiedContent<SwiftUI.TupleView<(SwiftUI.Button<SwiftUI.Text>, SwiftUI.Button<SwiftUI.Text>)>, SwiftUI.ButtonStyleModifier<SwiftUI.PlatformItemListButtonStyle>>, SwiftUI.Text>

public struct AlertModifier<Actions, Message>: ViewModifier {
    public let isPresented: Binding<Bool>
}

extension AlertModifier: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Alert"
        }

        func update(
            viewModifier: AlertModifier<Actions, Message>,
            context: inout Context
        ) {
        }

        func render(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {

        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

//
// Created by Mike on 8/13/21.
//

import RxSwift

public struct RefreshAction {
    fileprivate let action: () -> Void
    public func callAsFunction() {
        action()
    }
}

private struct RefreshActionKey: EnvironmentKey {
    static let defaultValue: RefreshAction? = nil
}

extension EnvironmentValues {
    public var refresh: RefreshAction? {
        get { self[RefreshActionKey.self] }
        set { self[RefreshActionKey.self] = newValue }
    }
}

extension View {

    /// Marks this view as refreshable.
    ///
    /// When you apply this modifier to a view, you set the
    /// ``EnvironmentValues/refresh`` value in the view's environment to the
    /// specified `action`.
    /// Controls that detect this action can change their appearance and provide
    /// a way for the user to execute a refresh.
    ///
    /// When you apply this modifier on iOS and iPadOS to a ``List``, the list
    /// provides a standard way for the user to refresh the content.
    /// When the user drags the top of the scrollable
    /// content area downward, the view reveals a refresh control and executes
    /// the provided action. Use an `await` expression inside the action to
    /// refresh your data. The refresh indicator remains visible for the
    /// duration of the awaited operation.
    ///
    ///     List(mailbox.conversations) {
    ///         ConversationCell($0)
    ///     }
    ///     .refreshable {
    ///         await mailbox.fetch()
    ///     }
    ///
    /// - Parameters:
    ///   - action: An async action that SwiftUI executes when the user performs
    ///   a standard gesture.
    ///   Use this action to initiate an update of model data that the
    ///   modified view displays. Use an `await` expression
    ///   inside the action. SwiftUI shows a refresh indicator, which stays
    ///   visible for the duration of the awaited operation.
    public func refreshable(action: @escaping () -> Void) ->
        ModifiedContent<Self, _EnvironmentKeyWritingModifier<RefreshAction?>> {

        environment(\.refresh, RefreshAction(action: action))
    }

    public func refreshable<O>(action: @escaping () -> O) ->
        ModifiedContent<Self, _EnvironmentKeyWritingModifier<RefreshAction?>>
        where O: ObservableConvertibleType {

        environment(\.refresh, RefreshAction {
            action().asObservable()
        })
    }
}

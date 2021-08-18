//
// Created by Mike on 8/14/21.
//

/// The context of the current state-processing update.
///
/// Use a transaction to pass an animation between views in a view hierarchy.
///
/// The root transaction for a state change comes from the binding that changed,
/// plus any global values set by calling ``withTransaction(_:_:)`` or
/// ``withAnimation(_:_:)``.
public struct Transaction {
    /// The overriden transaction for a state change in a `withTransaction` block.
    /// Is always set back to `nil` when the block exits.
    static var _active: Self?

    @usableFromInline
    internal var plist: PropertyList

    @inlinable
    public init() {
        plist = PropertyList()
    }
}

extension Transaction {

    /// Creates a transaction and assigns its animation property.
    ///
    /// - Parameter animation: The animation to perform when the current state
    ///   changes.
    @inlinable
    public init(animation: Animation?) {
        self.init()
        self.animation = animation
        disablesAnimations = false
    }

    /// The animation, if any, associated with the current state change.
    @inlinable
    public var animation: Animation? {
        get {
            TODO()
        }
        set {
            TODO()
        }
    }

    /// A Boolean value that indicates whether views should disable animations.
    ///
    /// This value is `true` during the initial phase of a two-part transition
    /// update, to prevent ``View/animation(_:)`` from inserting new animations
    /// into the transaction.
    @inlinable
    public var disablesAnimations: Bool {
        get {
            TODO()
        }
        set {
            TODO()
        }
    }
}

extension Transaction {

    /// A Boolean value that indicates whether the transaction originated from
    /// an action that produces a sequence of values.
    ///
    /// This value is `true` if a continuous action created the transaction, and
    /// is `false` otherwise. Continuous actions include things like dragging a
    /// slider or pressing and holding a stepper, as opposed to tapping a
    /// button.
    @inlinable
    public var isContinuous: Bool {
        get {
            TODO()
        }
        set {
            TODO()
        }
    }
}

/// Executes a closure with the specified transaction and returns the result.
///
/// - Parameters:
///   - transaction : An instance of a transaction, set as the thread's current
///     transaction.
///   - body: A closure to execute.
///
/// - Returns: The result of executing the closure with the specified
///   transaction.
public func withTransaction<Result>(
    _ transaction: Transaction,
    _ body: () throws -> Result
) rethrows -> Result {
    Transaction._active = transaction
    defer { Transaction._active = nil }
    return try body()
}

/// Returns the result of recomputing the view's body with the provided
/// animation.
///
/// This function sets the given ``Animation`` as the ``Transaction/animation``
/// property of the thread's current ``Transaction``.
public func withAnimation<Result>(
    _ animation: Animation? = .default,
    _ body: () throws -> Result
) rethrows -> Result {
    try withTransaction(.init(animation: animation), body)
}

protocol _TransactionModifierProtocol {
    func modifyTransaction(_ transaction: inout Transaction)
}

public struct _TransactionModifier: ViewModifier {
    public let transform: (inout Transaction) -> ()

    @inlinable
    public init(transform: @escaping (inout Transaction) -> ()) {
        self.transform = transform
    }

    public func body(content: Content) -> SomeView {
        content
    }
}

extension _TransactionModifier: _TransactionModifierProtocol {
    func modifyTransaction(_ transaction: inout Transaction) {
        transform(&transaction)
    }
}

extension ModifiedContent: _TransactionModifierProtocol
    where Modifier: _TransactionModifierProtocol
{
    func modifyTransaction(_ transaction: inout Transaction) {
        modifier.modifyTransaction(&transaction)
    }
}

public struct _PushPopTransactionModifier<V>: ViewModifier
    where V: ViewModifier {

    public let content: V
    public let base: _TransactionModifier

    @inlinable
    public init(
        content: V,
        transform: @escaping (inout Transaction) -> ()
    ) {
        self.content = content
        base = .init(transform: transform)
    }

    public func body(content: Content) -> SomeView {
        content
            .modifier(self.content)
            .modifier(base)
    }
}

extension View {

    /// Applies the given transaction mutation function to all animations used
    /// within the view.
    ///
    /// Use this modifier to change or replace the animation used in a view.
    /// Consider three identical animations controlled by a
    /// button that executes all three animations simultaneously:
    ///
    ///  * The first animation rotates the "Rotation" ``Text`` view by 360
    ///    degrees.
    ///  * The second uses the `transaction(_:)` modifier to change the
    ///    animation by adding a delay to the start of the animation
    ///    by two seconds and then increases the rotational speed of the
    ///    "Rotation\nModified" ``Text`` view animation by a factor of 2.
    ///  * The third animation uses the `transaction(_:)` modifier to
    ///    replace the rotation animation affecting the "Animation\nReplaced"
    ///    ``Text`` view with a spring animation.
    ///
    /// The following code implements these animations:
    ///
    ///     struct TransactionExample: View {
    ///         @State var flag = false
    ///
    ///         var body: some View {
    ///             VStack(spacing: 50) {
    ///                 HStack(spacing: 30) {
    ///                     Text("Rotation")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///
    ///                     Text("Rotation\nModified")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///                         .transaction { view in
    ///                             view.animation =
    ///                                 view.animation?.delay(2.0).speed(2)
    ///                         }
    ///
    ///                     Text("Animation\nReplaced")
    ///                         .rotationEffect(Angle(degrees:
    ///                                                 self.flag ? 360 : 0))
    ///                         .transaction { view in
    ///                             view.animation = .interactiveSpring(
    ///                                 response: 0.60,
    ///                                 dampingFraction: 0.20,
    ///                                 blendDuration: 0.25)
    ///                         }
    ///                 }
    ///
    ///                 Button("Animate") {
    ///                     withAnimation(.easeIn(duration: 2.0)) {
    ///                         self.flag.toggle()
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// Use this modifier on leaf views such as ``Image`` or ``Button`` rather
    /// than container views such as ``VStack`` or ``HStack``. The
    /// transformation applies to all child views within this view; calling
    /// `transaction(_:)` on a container view can lead to unbounded scope of
    /// execution depending on the depth of the view hierarchy.
    ///
    /// - Parameter transform: The transformation to apply to transactions
    ///   within this view.
    ///
    /// - Returns: A view that wraps this view and applies a transformation to
    ///   all transactions used within the view.
    @inlinable
    public func transaction(
        _ transform: @escaping (inout Transaction) -> Void
    ) -> ModifiedContent<Self, _TransactionModifier> {
        modifier(_TransactionModifier(transform: transform))
    }
}

public extension ViewModifier {

    /// Returns a new version of the modifier that will apply the
    /// transaction mutation function `transform` to all transactions
    /// within the modifier.
    @inlinable
    func transaction(
        _ transform: @escaping (inout Transaction) -> ()
    ) -> _PushPopTransactionModifier<Self> {
        _PushPopTransactionModifier(content: self, transform: transform)
    }

    /// Returns a new version of the modifier that will apply
    /// `animation` to all animatable values within the modifier.
    @inlinable
    func animation(
        _ animation: Animation?
    ) -> _PushPopTransactionModifier<Self> {
        transaction { t in
            if !t.disablesAnimations {
                t.animation = animation
            }
        }
    }
}

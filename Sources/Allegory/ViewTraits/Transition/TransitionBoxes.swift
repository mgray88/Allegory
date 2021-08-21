//
// Created by Mike on 8/19/21.
//

@usableFromInline
internal class _AnyTransitionBox: AnyTokenBox {
    @usableFromInline
    internal typealias ResolvedValue = ResolvedTransition

    @usableFromInline
    internal struct ResolvedTransition {
        internal var insertion: [Transition]
        internal var removal: [Transition]
        internal var insertionAnimation: Animation?
        internal var removalAnimation: Animation?

        internal init(
            insertion: [Transition],
            removal: [Transition],
            insertionAnimation: Animation?,
            removalAnimation: Animation?
        ) {
            self.insertion = insertion
            self.removal = removal
            self.insertionAnimation = insertionAnimation
            self.removalAnimation = removalAnimation
        }

        internal init(transitions: [Transition]) {
            self.init(
                insertion: transitions,
                removal: transitions,
                insertionAnimation: nil,
                removalAnimation: nil
            )
        }

        internal typealias Transition = (
            active: (AnyView) -> AnyView,
            identity: (AnyView) -> AnyView
        )
    }

    @usableFromInline
    internal func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        fatalError("implement \(#function) in subclass")
    }
}

final class IdentityTransitionBox: _AnyTransitionBox {
    override func resolve(in environment: EnvironmentValues) -> _AnyTransitionBox.ResolvedValue {
        .init(transitions: [])
    }
}

final class ConcreteTransitionBox: _AnyTransitionBox {
    let transition: ResolvedTransition.Transition

    init(_ transition: ResolvedTransition.Transition) {
        self.transition = transition
    }

    override func resolve(in environment: EnvironmentValues) -> _AnyTransitionBox.ResolvedValue {
        .init(transitions: [transition])
    }
}

final class AsymmetricTransitionBox: _AnyTransitionBox {
    let insertion: _AnyTransitionBox
    let removal: _AnyTransitionBox

    init(insertion: _AnyTransitionBox, removal: _AnyTransitionBox) {
        self.insertion = insertion
        self.removal = removal
    }

    override func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        let insertionResolved = insertion.resolve(in: environment)
        let removalResolved = removal.resolve(in: environment)
        return .init(
            insertion: insertionResolved.insertion,
            removal: removalResolved.removal,
            insertionAnimation: insertionResolved.insertionAnimation,
            removalAnimation: removalResolved.removalAnimation
        )
    }
}

final class CombinedTransitionBox: _AnyTransitionBox {
    let a: _AnyTransitionBox
    let b: _AnyTransitionBox

    init(a: _AnyTransitionBox, b: _AnyTransitionBox) {
        self.a = a
        self.b = b
    }

    override func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        let aResolved = a.resolve(in: environment)
        let bResolved = b.resolve(in: environment)
        return .init(
            insertion: aResolved.insertion + bResolved.insertion,
            removal: aResolved.removal + bResolved.removal,
            insertionAnimation: bResolved.insertionAnimation ?? aResolved.insertionAnimation,
            removalAnimation: bResolved.removalAnimation ?? aResolved.removalAnimation
        )
    }
}

final class AnimatedTransitionBox: _AnyTransitionBox {
    let animation: Animation?
    let parent: _AnyTransitionBox

    init(animation: Animation?, parent: _AnyTransitionBox) {
        self.animation = animation
        self.parent = parent
    }

    override func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        var resolved = parent.resolve(in: environment)
        resolved.insertionAnimation = animation
        resolved.removalAnimation = animation
        return resolved
    }
}

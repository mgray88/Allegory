//
// Created by Mike on 8/19/21.
//

public struct AnyTransition {
    fileprivate let box: _AnyTransitionBox

    private init(_ box: _AnyTransitionBox) {
        self.box = box
    }
}

public struct TransitionTraitKey: _ViewTraitKey {
    @inlinable public static var defaultValue: AnyTransition { .opacity }

    public typealias Value = AnyTransition
}

@usableFromInline
struct CanTransitionTraitKey: _ViewTraitKey {
    @inlinable static var defaultValue: Bool { false }

    @usableFromInline typealias Value = Bool
}

public extension _ViewTraitStore {
    var transition: AnyTransition { value(forKey: TransitionTraitKey.self) }
    var canTransition: Bool { value(forKey: CanTransitionTraitKey.self) }
}

extension View {
    @inlinable
    public func transition(
        _ t: AnyTransition
    ) -> ModifiedContent<Self, _TraitWritingModifier<TransitionTraitKey>> {
        _trait(TransitionTraitKey.self, t)
    }
}

/// A `ViewModifier` used to apply a primitive transition to a `View`.
public protocol _AnyTransitionModifier: ViewModifier, Animatable
    where Body == Self.Content
{
    var isActive: Bool { get }
}

public extension _AnyTransitionModifier {
    func _body(content: Content) -> Body {
        content
    }
}

public struct _MoveTransition: _AnyTransitionModifier {
    public let edge: Edge
    public let isActive: Bool
    public typealias Body = Self.Content
}

extension AnyTransition {
    public static let identity: AnyTransition = .init(IdentityTransitionBox())

    public static func move(edge: Edge) -> AnyTransition {
        modifier(
            active: _MoveTransition(edge: edge, isActive: true),
            identity: _MoveTransition(edge: edge, isActive: false)
        )
    }

    public static func asymmetric(
        insertion: AnyTransition,
        removal: AnyTransition
    ) -> AnyTransition {
        .init(AsymmetricTransitionBox(insertion: insertion.box, removal: removal.box))
    }

    public static func offset(_ offset: CGSize) -> AnyTransition {
        modifier(
            active: _OffsetEffect(offset: offset),
            identity: _OffsetEffect(offset: .zero)
        )
    }

    public static func offset(
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> AnyTransition {
        offset(.init(width: x, height: y))
    }

    public static var scale: AnyTransition { scale(scale: 0) }
    public static func scale(scale: CGFloat, anchor: UnitPoint = .center) -> AnyTransition {
        modifier(
            active: _ScaleEffect(scale: .init(width: scale, height: scale), anchor: anchor),
            identity: _ScaleEffect(scale: .init(width: 1, height: 1), anchor: anchor)
        )
    }

    public static let opacity: AnyTransition = modifier(
        active: _OpacityEffect(opacity: 0),
        identity: _OpacityEffect(opacity: 1)
    )

    public static let slide: AnyTransition = asymmetric(
        insertion: .move(edge: .leading),
        removal: .move(edge: .trailing)
    )

    public static func modifier<E>(
        active: E,
        identity: E
    ) -> AnyTransition where E: ViewModifier {
        .init(
            ConcreteTransitionBox(
                (active: {
                    AnyView($0.modifier(active))
                }, identity: {
                    AnyView($0.modifier(identity))
                })
            )
        )
    }

    public func combined(with other: AnyTransition) -> AnyTransition {
        .init(CombinedTransitionBox(a: box, b: other.box))
    }

    public func animation(_ animation: Animation?) -> AnyTransition {
        .init(AnimatedTransitionBox(animation: animation, parent: box))
    }
}

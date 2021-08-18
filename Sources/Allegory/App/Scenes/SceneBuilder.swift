//
// Created by Mike on 8/15/21.
//

@resultBuilder
public enum SceneBuilder {
    public static func buildBlock<Content: Scene>(_ content: Content) -> SomeScene {
        content
    }
}

// swiftlint:disable large_tuple
// swiftlint:disable function_parameter_count

public extension SceneBuilder {
    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> SomeScene
        where C0: Scene, C1: Scene {
        _TupleScene((c0, c1))
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> SomeScene
        where C0: Scene, C1: Scene, C2: Scene
    {
        _TupleScene((c0, c1, c2))
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene {
        _TupleScene(
            (c0, c1, c2, c3)
        )
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3, C4>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene, C4: Scene {
        _TupleScene(
            (c0, c1, c2, c3, c4)
        )
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3, C4, C5>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene, C4: Scene,
    C5: Scene
    {
        _TupleScene(
            (c0, c1, c2, c3, c4, c5)
        )
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene,
    C4: Scene, C5: Scene, C6: Scene
    {
        _TupleScene(
            (c0, c1, c2, c3, c4, c5, c6)
        )
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene, C4: Scene, C5: Scene, C6: Scene,
    C7: Scene
    {
        _TupleScene(
            (c0, c1, c2, c3, c4, c5, c6, c7)
        )
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene, C4: Scene, C5: Scene, C6: Scene,
    C7: Scene, C8: Scene
    {
        _TupleScene(
            (c0, c1, c2, c3, c4, c5, c6, c7, c8)
        )
    }
}

public extension SceneBuilder {
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8,
        _ c9: C9
    ) -> SomeScene where C0: Scene, C1: Scene, C2: Scene, C3: Scene, C4: Scene, C5: Scene, C6: Scene,
    C7: Scene, C8: Scene, C9: Scene
    {
        _TupleScene(
            (c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
        )
    }
}

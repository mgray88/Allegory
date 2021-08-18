//
// Created by Mike on 8/15/21.
//

public protocol _SceneModifier {
    associatedtype Body: Scene
    typealias SceneContent = _SceneModifier_Content<Self>
    func body(content: SceneContent) -> Self.Body
}

public struct _SceneModifier_Content<Modifier>: Scene
    where Modifier: _SceneModifier {

    public let modifier: Modifier
    public let scene: SomeScene
}

extension Scene {
    public func modifier<Modifier>(
        _ modifier: Modifier
    ) -> ModifiedContent<Self, Modifier> {
        .init(content: self, modifier: modifier)
    }
}

extension _SceneModifier where Body == Never {
    public func body(content: SceneContent) -> Body {
        fatalError("""
                   \(self) is a primitive `_SceneModifier`, you're not supposed to run `body(content:)`
                   """)
    }
}

extension ModifiedContent: Scene, SomeScene
    where Content: Scene, Modifier: _SceneModifier {}

extension ModifiedContent: _SceneModifier
    where Content: _SceneModifier, Modifier: _SceneModifier {}

//extension _PreferenceWritingModifier: _SceneModifier {
//    public typealias Body = Never
//}
//
//extension _PreferenceTransformModifier: _SceneModifier {
//    public typealias Body = Never
//}

extension _EnvironmentKeyWritingModifier: _SceneModifier {}

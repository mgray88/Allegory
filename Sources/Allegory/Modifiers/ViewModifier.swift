//
// Created by Mike on 7/29/21.
//

public protocol ViewModifier: SomeViewModifier {
    associatedtype Body: View
    typealias Content = ViewModifierContent<Self>
    func body(content: Content) -> Body
}

extension ViewModifier {
    public func body(content: SomeView) -> SomeView {
        (body(content: Content(content, modifier: self)) as Body) as SomeView
    }
}

extension ViewModifier where Body == Never {
    public func body(content: Content) -> Never {
        fatalError()
    }
}

public struct ViewModifierContent<VM: SomeViewModifier>: View {
    public let view: SomeView
    public let modifier: VM

    public init(_ view: SomeView, modifier: VM) {
        self.view = view
        self.modifier = modifier
    }

    public var body: Never {
        fatalError()
    }
}

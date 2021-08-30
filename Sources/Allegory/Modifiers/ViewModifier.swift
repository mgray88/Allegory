//
// Created by Mike on 7/29/21.
//

import UIKit

/// A modifier that you apply to a view or another view modifier, producing a
/// different version of the original value.
///
/// Adopt the ``ViewModifier`` protocol when you want to create a reusable
/// modifier that you can apply to any view. The example below combines several
/// modifiers to create a new modifier that you can use to create blue caption
/// text surrounded by a rounded rectangle:
///
///     struct BorderedCaption: ViewModifier {
///         func body(content: Content) -> SomeView {
///             content
///                 .font(.caption2)
///                 .padding(10)
///                 .overlay(
///                     RoundedRectangle(cornerRadius: 15)
///                         .stroke(lineWidth: 1)
///                 )
///                 .foregroundColor(Color.blue)
///         }
///     }
///
/// You can apply ``View/modifier(_:)`` directly to a view, but a more common
/// and idiomatic approach uses ``View/modifier(_:)`` to define an extension to
/// ``View`` itself that incorporates the view modifier:
///
///     extension View {
///         func borderedCaption() -> ModifiedContent<Self, BorderedCaption> {
///             modifier(BorderedCaption())
///         }
///     }
///
/// You can then apply the bordered caption to any view, similar to this:
///
///     Image(systemName: "bus")
///         .resizable()
///         .frame(width:50, height:50)
///     Text("Downtown Bus")
///         .borderedCaption()
///
public protocol ViewModifier: SomeViewModifier {
    associatedtype Body: View
    typealias Content = _ViewModifier_Content<Self>
    func _body(content: Content) -> Body

    /// Gets the current body of the caller.
    ///
    /// `content` is a proxy for the view that will have the modifier
    /// represented by `Self` applied to it.
    @ViewBuilder
    func body(content: Content) -> SomeView
}

internal protocol _PrimitiveViewModifier {
    func modify(view: UIView)
}

extension ViewModifier {
    public func body(content: SomeView) -> SomeView {
        body(content: Content(content, modifier: self))
    }

    public func body(content: Content) -> SomeView {
        abstractMethod()
    }
}

extension ViewModifier where Body == Never {
    public func _body(content: Content) -> Never {
        fatalError(
            "\(Self.self) is a primitive `ViewModifier`, you're not supposed to run `_body(content:)`"
        )
    }
}

extension ViewModifier {
    /// Returns a new modifier that is the result of concatenating
    /// `self` with `modifier`.
    @inlinable
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        ModifiedContent(content: self, modifier: modifier)
    }
}

public struct _ViewModifier_Content<VM: SomeViewModifier>: View {
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

extension _ViewModifier_Content: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "ViewModifierContent<\(content.hierarchyIdentifier)>"
        }

        var content: SomeUIKitNode!

        func update(view: _ViewModifier_Content<VM>, context: Context) {
            content = view.view.resolve(context: context, cachedNode: content)
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            content.size(fitting: proposedSize, pass: pass)
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            content.render(in: container, bounds: bounds, pass: pass)
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

//
// Created by Mike on 7/30/21.
//

protocol UIKitNodeModifierResolvable {
    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier
}

extension SomeViewModifier {

    internal func resolve(
        context: inout Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier? {
        if let viewModifier = self as? UIKitNodeModifierResolvable {
            let resolvedNodeModifier = viewModifier.resolve(
                context: context,
                cachedNodeModifier: cachedNodeModifier
            )
            resolvedNodeModifier.update(viewModifier: self, context: &context)
            return resolvedNodeModifier
        } else {
            return nil
        }
    }
}

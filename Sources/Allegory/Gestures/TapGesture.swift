//
// Created by Mike on 8/3/21.
//

import UIKit.UIGestureRecognizer

public struct TapGesture: Gesture {
    public typealias Value = ()

    public var count: Int

    @inlinable
    public init(count: Int = 1) {
        self.count = count
    }
}

extension View {
    /// Adds an action to perform when this view recognizes a tap gesture.
    ///
    /// Use this method to perform a specific `action` when the user clicks or
    /// taps on the view or container `count` times.
    ///
    /// > Note: If you are creating a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// In the example below, the color of the heart images changes to a random
    /// color from the `colors` array whenever the user clicks or taps on the
    /// view twice:
    ///
    ///     struct TapGestureExample: View {
    ///         let colors: [Color] = [.gray, .red, .orange, .yellow,
    ///                                .green, .blue, .purple, .pink]
    ///         @State private var fgColor: Color = .gray
    ///
    ///         var body: some View {
    ///             Image(systemName: "heart.fill")
    ///                 .resizable()
    ///                 .frame(width: 200, height: 200)
    ///                 .foregroundColor(fgColor)
    ///                 .onTapGesture(count: 2, perform: {
    ///                     fgColor = colors.randomElement()!
    ///                 })
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - action: The action to perform.
    @inlinable
    public func onTapGesture(
        count: Int = 1,
        perform action: @escaping () -> Void
    ) -> ModifiedContent<Self, _AddGestureModifier<_EndedGesture<TapGesture>>> {
        gesture(TapGesture(count: count).onEnded(action))
    }
}

extension TapGesture: ResolvableGesture {
    func resolve(
        cachedGestureRecognizer: UIGestureRecognizer?
    ) -> GestureController {
        TapGestureController(
            cachedGestureRecognizer: cachedGestureRecognizer,
            gesture: self
        )
    }
}

private class TapGestureController: GestureController {
    var _gestureRecognizer: UIGestureRecognizer {
        gestureRecognizer
    }

    let gestureRecognizer: UITapGestureRecognizer
    var endAction: ((()) -> Void)?

    init(cachedGestureRecognizer: UIGestureRecognizer?, gesture: TapGesture) {
        gestureRecognizer = (cachedGestureRecognizer as? UITapGestureRecognizer)
            ?? UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = gesture.count
        setupTarget()
    }

    func setupTarget() {
        gestureRecognizer.addTarget(self, action: #selector(didTap))
    }

    func registerEndAction<T>(_ action: T) {
        endAction = action as? (()) -> Void
    }

    @objc func didTap() {
        endAction?(())
    }
}

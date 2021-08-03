//
// Created by Mike on 8/3/21.
//

extension ViewModifiers {
    public struct _Gesture<G: SomeGesture>: ViewModifier {
        public enum Priority {
            case low
            case high
            case simultaneous
        }

        public let gesture: G
        public let priority: Priority

        @inlinable
        public init(_ gesture: G, priority: Priority) {
            self.gesture = gesture
            self.priority = priority
        }
    }
}

extension View {
    /// Attaches a gesture to the view with a lower precedence than gestures
    /// defined by the view.
    ///
    /// Use this method when you need to attach a gesture to a view. The
    /// example below defines a custom gesture that prints a message to the
    /// console and attaches it to the view's ``VStack``. Inside the ``VStack``
    /// a red heart ``Image`` defines its own ``TapGesture``
    /// handler that also prints a message to the console, and blue rectangle
    /// with no custom gesture handlers. Tapping or clicking the image
    /// prints a message to the console from the tap gesture handler on the
    /// image, while tapping or clicking  the rectangle inside the ``VStack``
    /// prints a message in the console from the enclosing vertical stack
    /// gesture handler.
    ///
    ///     struct GestureExample: View {
    ///         @State private var message = "Message"
    ///         let newGesture = TapGesture().onEnded {
    ///             print("Tap on VStack.")
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing:25) {
    ///                 Image(systemName: "heart.fill")
    ///                     .resizable()
    ///                     .frame(width: 75, height: 75)
    ///                     .padding()
    ///                     .foregroundColor(.red)
    ///                     .onTapGesture {
    ///                         print("Tap on image.")
    ///                     }
    ///                 Rectangle()
    ///                     .fill(Color.blue)
    ///             }
    ///             .gesture(newGesture)
    ///             .frame(width: 200, height: 200)
    ///             .border(Color.purple)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - gesture: A gesture to attach to the view.
    @inlinable
    public func gesture<T>(
        _ gesture: T
    ) -> ModifiedContent<Self, ViewModifiers._Gesture<T>> where T: SomeGesture {
        modifier(ViewModifiers._Gesture(gesture, priority: .low))
    }

    /// Attaches a gesture to the view with a higher precedence than gestures
    /// defined by the view.
    ///
    /// Use this method when you need to define a high priority gesture
    /// to take precedence over the view's existing gestures. The
    /// example below defines a custom gesture that prints a message to the
    /// console and attaches it to the view's ``VStack``. Inside the ``VStack``
    /// a red heart ``Image`` defines its own ``TapGesture`` handler that
    /// also prints a message to the console, and a blue rectangle
    /// with no custom gesture handlers. Tapping or clicking any of the
    /// views results in a console message from the high priority gesture
    /// attached to the enclosing ``VStack``.
    ///
    ///     struct HighPriorityGestureExample: View {
    ///         @State private var message = "Message"
    ///         let newGesture = TapGesture().onEnded {
    ///             print("Tap on VStack.")
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing:25) {
    ///                 Image(systemName: "heart.fill")
    ///                     .resizable()
    ///                     .frame(width: 75, height: 75)
    ///                     .padding()
    ///                     .foregroundColor(.red)
    ///                     .onTapGesture {
    ///                         print("Tap on image.")
    ///                     }
    ///                 Rectangle()
    ///                     .fill(Color.blue)
    ///             }
    ///             .highPriorityGesture(newGesture)
    ///             .frame(width: 200, height: 200)
    ///             .border(Color.purple)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - gesture: A gesture to attach to the view.
    @inlinable
    public func highPriorityGesture<T>(
        _ gesture: T
    ) -> ModifiedContent<Self, ViewModifiers._Gesture<T>> where T: SomeGesture {
        modifier(ViewModifiers._Gesture(gesture, priority: .high))
    }

    /// Attaches a gesture to the view to process simultaneously with gestures
    /// defined by the view.
    ///
    /// Use this method when you need to define and process  a view specific
    /// gesture simultaneously with the same priority as the
    /// view's existing gestures. The example below defines a custom gesture
    /// that prints a message to the console and attaches it to the view's
    /// ``VStack``. Inside the ``VStack`` is a red heart ``Image`` defines its
    /// own ``TapGesture`` handler that also prints a message to the console
    /// and a blue rectangle with no custom gesture handlers.
    ///
    /// Tapping or clicking the "heart" image sends two messages to the
    /// console: one for the image's tap gesture handler, and the other from a
    /// custom gesture handler attached to the enclosing vertical stack.
    /// Tapping or clicking on the blue rectangle results only in the single
    /// message to the console from the tap recognizer attached to the
    /// ``VStack``:
    ///
    ///     struct SimultaneousGestureExample: View {
    ///         @State private var message = "Message"
    ///         let newGesture = TapGesture().onEnded {
    ///             print("Gesture on VStack.")
    ///         }
    ///
    ///         var body: some View {
    ///             VStack(spacing:25) {
    ///                 Image(systemName: "heart.fill")
    ///                     .resizable()
    ///                     .frame(width: 75, height: 75)
    ///                     .padding()
    ///                     .foregroundColor(.red)
    ///                     .onTapGesture {
    ///                         print("Gesture on image.")
    ///                     }
    ///                 Rectangle()
    ///                     .fill(Color.blue)
    ///             }
    ///             .simultaneousGesture(newGesture)
    ///             .frame(width: 200, height: 200)
    ///             .border(Color.purple)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///    - gesture: A gesture to attach to the view.
    @inlinable
    public func simultaneousGesture<T>(
        _ gesture: T
    ) -> ModifiedContent<Self, ViewModifiers._Gesture<T>> where T: SomeGesture {
        modifier(ViewModifiers._Gesture(gesture, priority: .simultaneous))
    }
}

extension ViewModifiers._Gesture: UIKitNodeModifierResolvable {
    private class Node: UIKitNodeModifier {
        var hierarchyIdentifier: String {
            "Gesture"
        }

        let gestureView = GestureView()

        func update(
            viewModifier: ViewModifiers._Gesture<G>,
            context: inout Context
        ) {
            let gesture = viewModifier.gesture as! ResolvableGesture
            gestureView.gestureController = gesture.resolve(
                cachedGestureRecognizer: gestureView
                    .gestureController?._gestureRecognizer
            )
        }

        func layout(
            in container: Container,
            bounds: Bounds,
            pass: LayoutPass,
            node: SomeUIKitNode
        ) {
            gestureView.frame = bounds.rect
            container.view.addSubview(gestureView)
            gestureView.replaceSubnodes {
                node.layout(
                    in: container.replacingView(gestureView),
                    bounds: bounds.at(origin: .zero),
                    pass: pass
                )
            }
        }
    }

    func resolve(
        context: Context,
        cachedNodeModifier: AnyUIKitNodeModifier?
    ) -> AnyUIKitNodeModifier {
        (cachedNodeModifier as? Node) ?? Node()
    }
}

extension ViewModifiers._Gesture {
    class GestureView: ContainerView {
        var didEndAction: (() -> Void)?

        fileprivate var gestureController: GestureController? {
            didSet {
                guard let gestureController = gestureController else { return }
                if let oldGestureController = oldValue {
                    if oldGestureController._gestureRecognizer
                           != gestureController._gestureRecognizer {
                        removeGestureRecognizer(
                            oldGestureController._gestureRecognizer
                        )
                        addGestureRecognizer(
                            gestureController._gestureRecognizer
                        )
                    }
                } else {
                    addGestureRecognizer(gestureController._gestureRecognizer)
                }
            }
        }

        @objc func didEnd() {
            didEndAction?()
        }
    }
}

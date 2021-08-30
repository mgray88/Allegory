//
// Created by Mike on 7/30/21.
//

import UIKit

/// A UIKit view controller that manages an Allegory view hierarchy.
///
/// Create a `UIHostingController` object when you want to integrate Allegory
/// views into a UIKit view hierarchy. At creation time, specify the Allegory
/// view you want to use as the root view for this view controller; you can
/// change that view later using the ``Allegory/UIHostingController/rootView``
/// property. Use the hosting controller like you would any other view
/// controller, by presenting it or embedding it as a child view controller
/// in your interface.
open class UIHostingController<Content>: UIViewController where Content: View {

    /// The root view of the Allegory view hierarchy managed by this view
    /// controller.
    public var rootView: Content

    private var hostView: _UIHostingView {
        // swiftlint:disable:next
        view as! _UIHostingView
    }

    /// Creates a hosting controller object that wraps the specified Allegory
    /// view.
    ///
    /// - Parameter rootView: The root view of the Allegory view hierarchy that
    ///   you want to manage using the hosting view controller.
    ///
    /// - Returns: A `UIHostingController` object initialized with the
    ///   specified Allegory view.
    public init(rootView: Content) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }

    /// Creates a hosting controller object that wraps the specified Allegory
    /// view.
    ///
    /// - Parameter rootView: The root view of the Allegory view hierarchy that
    ///   you want to manage using the hosting view controller.
    ///
    /// - Returns: A `UIHostingController` object initialized with the
    ///   specified Allegory view.
    public convenience init(@ViewBuilder rootView: () -> Content) {
        self.init(rootView: rootView())
    }

    /// Creates a hosting controller object from an archive and the specified
    /// Allegory view.
    /// - Parameters:
    ///   - coder: The decoder to use during initialization.
    ///   - rootView: The root view of the Allegory view hierarchy that you want
    ///     to manage using this view controller.
    ///
    /// - Returns: A `UIViewController` object that you can present from your
    ///   interface.
    public init?(coder aDecoder: NSCoder, rootView: Content) {
        notSupported()
    }

    /// Creates a hosting controller object from the contents of the specified
    /// archive.
    ///
    /// The default implementation of this method throws an exception. To create
    /// your view controller from an archive, override this method and
    /// initialize the superclass using the ``init(coder:rootView:)`` method
    /// instead.
    ///
    /// -Parameter coder: The decoder to use during initialization.
    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        notSupported()
    }

    @_spi(Internal)
    @objc override dynamic open func loadView() {
        view = _UIHostingView(rootView: rootView)
        view.backgroundColor = .white
    }

    /// Notifies the view controller that its view is about to be added to a
    /// view hierarchy.
    ///
    /// Allegory calls this method before adding the hosting controller's root
    /// view to the view hierarchy. You can override this method to perform
    /// custom tasks associated with the appearance of the view. If you
    /// override this method, you must call `super` at some point in your
    /// implementation.
    ///
    /// - Parameter animated: If `true`, the view is being added
    ///   using an animation.
    @objc override dynamic open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /// Notifies the view controller that its view has been added to a
    /// view hierarchy.
    ///
    /// Allegory calls this method after adding the hosting controller's root
    /// view to the view hierarchy. You can override this method to perform
    /// custom tasks associated with the appearance of the view. If you
    /// override this method, you must call `super` at some point in your
    /// implementation.
    ///
    /// - Parameter animated: If `true`, the view is being added
    ///   using an animation.
    @objc override dynamic open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /// Notifies the view controller that its view will be removed from a
    /// view hierarchy.
    ///
    /// Allegory calls this method before removing the hosting controller's root
    /// view from the view hierarchy. You can override this method to perform
    /// custom tasks associated with the disappearance of the view. If you
    /// override this method, you must call `super` at some point in your
    /// implementation.
    ///
    /// - Parameter animated: If `true`, the view is being removed
    ///   using an animation.
    @objc override dynamic open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc override dynamic open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @objc override dynamic open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    @available(iOS 13, *)
    @objc override dynamic open var isModalInPresentation: Bool {
        get {
            super.isModalInPresentation
        }
        set {
            super.isModalInPresentation = newValue
        }
    }

    @objc override dynamic open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = hostView.layoutSize(fitting: view.bounds.size)
        hostView.frame.size = size
        hostView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
}

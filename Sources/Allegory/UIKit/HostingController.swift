//
// Created by Mike on 7/30/21.
//
import UIKit

open class HostingController: UIViewController {

    public let hostingView: HostingView

    public init(rootView: SomeView) {
        self.hostingView = HostingView(rootView: rootView)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(hostingView)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = hostingView.layoutSize(fitting: view.bounds.size)
        hostingView.frame.size = size
        hostingView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
}

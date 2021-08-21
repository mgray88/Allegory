//
// Created by Mike on 8/3/21.
//

import UIKit

/// A view that displays an image.
///
/// Use an `Image` instance when you want to add images to your Allegory app.
/// You can create images from many sources:
///
/// * Image files in your app's asset library or bundle. Supported types include
/// PNG, JPEG, HEIC, and more.
/// * Instances of platform-specific image types, like
/// <doc://com.apple.documentation/documentation/UIKit/UIImage> and
/// <doc://com.apple.documentation/documentation/AppKit/NSImage>.
/// * A bitmap stored in a Core Graphics
///  <doc://com.apple.documentation/documentation/coregraphics/cgimage>
///  instance.
/// * System graphics from the SF Symbols set.
///
/// The following example shows how to load an image from the app's asset
/// library or bundle and scale it to fit within its container:
///
///     Image("Landscape_4")
///         .resizable()
///         .aspectRatio(contentMode: .fit)
///     Text("Water wheel")
///
/// You can use methods on the `Image` type as well as
/// standard view modifiers to adjust the size of the image to fit your app's
/// interface. Here, the `Image` type's
/// ``Image/resizable(capInsets:resizingMode:)`` method scales the image to fit
/// the current view. Then, the
/// ``View/aspectRatio(_:contentMode:)-771ow`` view modifier adjusts
/// this resizing behavior to maintain the image's original aspect ratio, rather
/// than scaling the x- and y-axes independently to fill all four sides of the
/// view.
///
/// An `Image` is a late-binding token; the system resolves its actual value
/// only when it's about to use the image in an environment.
///
/// ### Making Images Accessible
///
/// To use an image as a control, use one of the initializers that takes a
/// `label` parameter. This allows the system's accessibility frameworks to use
/// the label as the name of the control for users who use features like
/// VoiceOver. For images that are only present for aesthetic reasons, use an
/// initializer with the `decorative` parameter; the accessibility systems
/// ignore these images.
public struct Image: View, Hashable {
    public typealias Body = Swift.Never

    @usableFromInline
    internal let provider: AnyImageProviderBox

    @inlinable
    internal init(_ provider: AnyImageProviderBox) {
        self.provider = provider
    }
}

extension Image {

    /// Creates a labeled image that you can use as content for controls.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup, as well as the
    ///     localization key with which to label the image.
    ///   - bundle: The bundle to search for the image resource and localization
    ///     content. If `nil`, Allegory uses the main `Bundle`. Defaults to
    ///     `nil`.
    @inlinable
    public init(_ name: String, bundle: Bundle? = nil) {
        self.init(NamedImageProvider(name: name, bundle: bundle, label: Text(name)))
    }

    /// Creates a labeled image that you can use as content for controls, with
    /// the specified label.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup
    ///   - bundle: The bundle to search for the image resource. If `nil`,
    ///     Allegory uses the main `Bundle`. Defaults to `nil`.
    ///   - label: The label associated with the image. Allegory uses the label
    ///     for accessibility.
    @inlinable
    public init(_ name: String, bundle: Bundle? = nil, label: Text) {
        self.init(NamedImageProvider(name: name, bundle: bundle, label: label))
    }

    /// Creates an unlabeled, decorative image.
    ///
    /// Allegory ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup
    ///   - bundle: The bundle to search for the image resource. If `nil`,
    ///     Allegory uses the main `Bundle`. Defaults to `nil`.
    @inlinable
    public init(decorative name: String, bundle: Bundle? = nil) {
        self.init(NamedImageProvider(name: name, bundle: bundle, label: nil))
    }

    /// Creates a system symbol image.
    ///
    /// This initializer creates an image using a system-provided symbol. To
    /// create a custom symbol image from your app's asset catalog, use
    /// ``Image/init(_:bundle:)`` instead.
    ///
    /// - Parameters:
    ///   - systemName: The name of the system symbol image.
    ///     Use the SF Symbols app to look up the names of system symbol images.
    @available(iOS 13.0, *)
    public init(systemName: String) {
        self.init(SystemImageProvider(systemName: systemName))
    }
}

extension Image {
    /// Sets the mode by which Allegory resizes an image to fit its space.
    ///
    /// - Parameters:
    ///   - capInsets: Inset values that indicate a portion of the image that
    ///     Allegory doesn't resize.
    ///   - resizingMode: The mode by which Allegory resizes the image.
    /// - Returns: An image, with the new resizing behavior set.
    public func resizable(
        capInsets: EdgeInsets = EdgeInsets(),
        resizingMode: Image.ResizingMode = .stretch
    ) -> Image {
        Image(
            ResizableProvider(
                parent: self.provider,
                capInsets: capInsets,
                resizingMode: resizingMode
            )
        )
    }
}

extension Image: UIKitNodeResolvable {
    private class Node: UIImageView, UIKitNode {
        var hierarchyIdentifier: String {
            "Image"
        }

        var imageView: Image!
        var resizable: Bool!

        func update(view: Image, context: Context) {
            imageView = view
            let resolved = view.provider.resolve(in: context.environment)
            image = resolved.image
            resizable = resolved.isResizable
            if let label = resolved.label {
                self.isAccessibilityElement = true
                if #available(iOS 11.0, *) {
                    self.accessibilityAttributedLabel =
                        label.storage.attributedStringValue(baseFont: .body)
                } else {
                    self.accessibilityLabel =
                        label.storage.stringValue
                }
            } else {
                self.isAccessibilityElement = false
            }
        }

        func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            if resizable {
                return proposedSize.or(image?.size)
            } else {
                return image?.size ?? .zero
            }
        }

        func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
            container.view.addSubview(self)
            self.frame = bounds.rect
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

@usableFromInline
internal class AnyImageProviderBox: AnyTokenBox, Hashable {
    @usableFromInline
    internal struct _Image {
        internal indirect enum Storage {
            case named(String, bundle: Bundle?)
            case systemName(String)
            case resizable(Storage, capInsets: EdgeInsets, resizingMode: Image.ResizingMode)

            fileprivate var image: UIImage? {
                switch self {
                case let .named(name, bundle):
                    return UIImage(named: name, in: bundle, compatibleWith: nil)

                case let .systemName(systemName):
                    if #available(iOS 13, *) {
                        return UIImage(systemName: systemName)
                    }
                    return nil

                case let .resizable(parent, capInsets, resizingMode):
                    guard let parent = parent.image else { return nil }
                    return parent.resizableImage(
                        withCapInsets: capInsets.uiEdgeInsets,
                        resizingMode: resizingMode.uiImageResizingMode
                    )
                }
            }
        }

        internal let storage: Storage
        internal let label: Text?
        internal var isResizable: Bool {
            guard case .resizable = storage else { return false }
            return true
        }
        internal var image: UIImage? { storage.image }
    }

    @inlinable
    internal static func == (lhs: AnyImageProviderBox, rhs: AnyImageProviderBox) -> Bool {
        lhs.equals(rhs)
    }

    @inlinable
    internal func hash(into hasher: inout Hasher) {
        fatalError("implement \(#function) in subclass")
    }

    @inlinable
    internal func equals(_ other: AnyImageProviderBox) -> Bool {
        fatalError("implement \(#function) in subclass")
    }

    @inlinable
    internal func resolve(in environment: EnvironmentValues) -> _Image {
        fatalError("implement \(#function) in subclass")
    }
}

//extension AnyImageProviderBox: UIKitNode {
//    var hierarchyIdentifier: String {
//        "Image"
//    }
//
//    func update(view: Image, context: Context) {
//
//    }
//
//    func size(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
//
//    }
//
//    func render(in container: Container, bounds: Bounds, pass: LayoutPass) {
//
//    }
//}

@usableFromInline
internal class NamedImageProvider: AnyImageProviderBox {
    let name: String
    let bundle: Bundle?
    let label: Text?

    @usableFromInline
    init(name: String, bundle: Bundle?, label: Text?) {
        self.name = name
        self.bundle = bundle
        self.label = label
    }

    override func hash(into hasher: inout Hasher) {
        name.hash(into: &hasher)
        bundle?.hash(into: &hasher)
        label?.hash(into: &hasher)
    }

    override func equals(_ other: AnyImageProviderBox) -> Bool {
        guard let other = other as? NamedImageProvider else { return false }
        return other.name == name
            && other.bundle?.bundlePath == bundle?.bundlePath
            && other.label == label
    }

    override func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        .init(storage: .named(name, bundle: bundle), label: label)
    }
}

@usableFromInline
internal class SystemImageProvider: AnyImageProviderBox {
    let systemName: String

    @usableFromInline
    init(systemName: String) {
        self.systemName = systemName
    }

    override func hash(into hasher: inout Hasher) {
        systemName.hash(into: &hasher)
    }

    override func equals(_ other: AnyImageProviderBox) -> Bool {
        guard let other = other as? SystemImageProvider else { return false }
        return systemName == other.systemName
    }

    override func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        .init(storage: .systemName(systemName), label: nil)
    }
}

@usableFromInline
internal class ResizableProvider: AnyImageProviderBox {
    let parent: AnyImageProviderBox
    let capInsets: EdgeInsets
    let resizingMode: Image.ResizingMode

    @usableFromInline
    init(parent: AnyImageProviderBox, capInsets: EdgeInsets, resizingMode: Image.ResizingMode) {
        self.parent = parent
        self.capInsets = capInsets
        self.resizingMode = resizingMode
    }

    override func hash(into hasher: inout Hasher) {
        parent.hash(into: &hasher)
        capInsets.hash(into: &hasher)
        resizingMode.hash(into: &hasher)
    }

    override func equals(_ other: AnyImageProviderBox) -> Bool {
        guard let other = other as? ResizableProvider else { return false }
        return other.parent.equals(parent)
            && other.capInsets == capInsets
            && other.resizingMode == resizingMode
    }

    override func resolve(in environment: EnvironmentValues) -> ResolvedValue {
        let resolved = parent.resolve(in: environment)
        return .init(
            storage: .resizable(
                resolved.storage,
                capInsets: capInsets,
                resizingMode: resizingMode
            ),
            label: resolved.label
        )
    }
}

//
// Created by Mike on 8/3/21.
//

import UIKit

/// A view that displays an image.
///
/// Use an `Image` instance when you want to add images to your TOCUIKit app.
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
/// view. The article
/// <doc:Fitting-Images-into-Available-Space> shows how to apply scaling,
/// clipping, and tiling to `Image` instances of different sizes.
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

    internal let name: String
    internal let bundle: Bundle?
    internal let label: Text?
    internal var isResizable = false
    internal var capInsets: EdgeInsets?
    internal var resizingMode: ResizingMode?

    /// Creates a labeled image that you can use as content for controls.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup, as well as the
    ///     localization key with which to label the image.
    ///   - bundle: The bundle to search for the image resource and localization
    ///     content. If `nil`, TOCUIKit uses the main `Bundle`. Defaults to
    ///     `nil`.
    public init(_ name: String, bundle: Bundle? = nil) {
        self.name = name
        self.bundle = bundle
        self.label = Text(name)
    }

    /// Creates a labeled image that you can use as content for controls, with
    /// the specified label.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup
    ///   - bundle: The bundle to search for the image resource. If `nil`,
    ///     TOCUIKit uses the main `Bundle`. Defaults to `nil`.
    ///   - label: The label associated with the image. TOCUIKit uses the label
    ///     for accessibility.
    public init(_ name: String, bundle: Bundle? = nil, label: Text) {
        self.name = name
        self.bundle = bundle
        self.label = label
    }

    /// Creates an unlabeled, decorative image.
    ///
    /// TOCUIKit ignores this image for accessibility purposes.
    ///
    /// - Parameters:
    ///   - name: The name of the image resource to lookup
    ///   - bundle: The bundle to search for the image resource. If `nil`,
    ///     TOCUIKit uses the main `Bundle`. Defaults to `nil`.
    public init(decorative name: String, bundle: Bundle? = nil) {
        self.name = name
        self.bundle = bundle
        self.label = nil
    }
}

extension Image {
    /// Sets the mode by which TOCUIKit resizes an image to fit its space.
    ///
    /// - Parameters:
    ///   - capInsets: Inset values that indicate a portion of the image that
    ///     TOCUIKit doesn't resize.
    ///   - resizingMode: The mode by which TOCUIKit resizes the image.
    /// - Returns: An image, with the new resizing behavior set.
    public func resizable(
        capInsets: EdgeInsets = EdgeInsets(),
        resizingMode: Image.ResizingMode = .stretch
    ) -> Image {
        var copy = self
        copy.isResizable = true
        copy.capInsets = capInsets
        copy.resizingMode = resizingMode
        return copy
    }
}

extension Image: UIKitNodeResolvable {
    private class Node: UIKitNode {
        var hierarchyIdentifier: String {
            "Image"
        }

        var imageView: Image!
        var uiImage: UIImage?

        let uiImageView = UIImageView()

        func update(view: Image, context: Context) {
            imageView = view
            uiImage = UIImage(named: view.name)
            if imageView.isResizable,
               let capInsets = imageView.capInsets {
                if let resizingMode = imageView.resizingMode {
                    uiImage = uiImage?.resizableImage(
                        withCapInsets: capInsets.uiEdgeInsets,
                        resizingMode: resizingMode.uiImageResizingMode
                    )
                } else {
                    uiImage = uiImage?.resizableImage(
                        withCapInsets: capInsets.uiEdgeInsets
                    )
                }
            }
            if let label = imageView.label {
                uiImageView.isAccessibilityElement = true
                if #available(iOS 11.0, *) {
                    uiImageView.accessibilityAttributedLabel =
                        label.storage.attributedStringValue(baseFont: .body)
                } else {
                    uiImageView.accessibilityLabel =
                        label.storage.stringValue
                }
            } else {
                uiImageView.isAccessibilityElement = false
            }
            uiImageView.image = uiImage
        }

        func layoutSize(fitting proposedSize: ProposedSize, pass: LayoutPass) -> CGSize {
            if imageView.isResizable {
                return proposedSize.or(uiImage?.size)
            } else {
                return uiImage?.size ?? .zero
            }
        }

        func layout(in container: Container, bounds: Bounds, pass: LayoutPass) {
            container.view.addSubview(uiImageView)
            uiImageView.frame = bounds.rect
        }
    }

    func resolve(context: Context, cachedNode: SomeUIKitNode?) -> SomeUIKitNode {
        (cachedNode as? Node) ?? Node()
    }
}

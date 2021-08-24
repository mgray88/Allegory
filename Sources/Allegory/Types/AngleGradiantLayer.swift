//
// Created by Mike on 8/21/21.
//

import QuartzCore

internal protocol GradientLayerProtocol: AnyObject {
    var colors: [CGColor]? { get set }
    var locations: [CGFloat]? { get set }
    var startPoint: CGPoint { get set }
    var endPoint: CGPoint { get set }
}

internal class AngularGradientLayer: CALayer, GradientLayerProtocol {
    var colors: [CGColor]?
    var locations: [CGFloat]?
    var startPoint: CGPoint = UnitPoint.top.cgPoint
    var endPoint: CGPoint = UnitPoint.bottom.cgPoint
    internal var center: UnitPoint = .center
    internal var startAngle: Angle = .zero
    internal var endAngle: Angle = .radians(2 * Double.pi)

//    override func draw(in ctx: CGContext) {
//        ctx.setFillColor(backgroundColor ?? UIColor.black.cgColor)
//        ctx.rotate(by: startAngle.radians.cgFloat)
//        let rect = ctx.boundingBoxOfClipPath
//        ctx.fill(rect)
//
//        let image = imageGradient(in: rect)
//        ctx.draw(image, in: rect)
//    }
//
//    private func imageGradient(in rect: CGRect) -> CGImage {
//        let width = Int(rect.width)
//        let height = Int(rect.height)
//        let bitsPerComponent = 8
//        let bpp = 4 * bitsPerComponent / 8
//        let byteCount = width * height * bpp
//
//        let colorCount = colors?.count ?? 0
//        let locationCount = locations?.count ?? 0
//
//        if colorCount > 0, let colors = colors {
//            for color in colors {
//                guard let color = color as? CGColor else { continue }
//
//            }
//        }
//
//        let data = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: <#T##Int##Swift.Int#>)
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(
//            rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
//        ).rawValue
//        let ctx = CGContext(
//            data: <#T##UnsafeMutableRawPointer?##Swift.UnsafeMutableRawPointer?#>,
//            width: <#T##Int##Swift.Int#>,
//            height: <#T##Int##Swift.Int#>,
//            bitsPerComponent: <#T##Int##Swift.Int#>,
//            bytesPerRow: <#T##Int##Swift.Int#>,
//            space: colorSpace,
//            bitmapInfo: bitmapInfo
//        )
//        ctx?.makeImage()
//    }
}

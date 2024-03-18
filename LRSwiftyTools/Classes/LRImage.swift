import Foundation
import UIKit
@objc public extension UIImage {
    @objc class func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    @objc func fixOrientation() -> UIImage {
        if self.imageOrientation == .up { return self }
        var transform: CGAffineTransform = .identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -(.pi / 2.0))
        default: break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default: break
        }
        guard let cgImg = self.cgImage, let colorSpace = cgImg.colorSpace, let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImg.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImg.bitmapInfo.rawValue) else {
            return self
        }
        ctx.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImg, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx.draw(cgImg, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        guard let img = ctx.makeImage() else {
            return self
        }
        let newImage = UIImage(cgImage: img)
        return newImage
    }
}

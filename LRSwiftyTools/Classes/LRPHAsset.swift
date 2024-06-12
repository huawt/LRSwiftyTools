import Foundation
import Photos
import AVKit
@objcMembers
open class LRPHAsset: NSObject {
    @objc public class func getVideoImage(by urlString: String, second: Float64 = 0) -> UIImage? {
        guard let url = URL(string: urlString) else{ return nil }
        let asset = AVURLAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        let time = CMTimeMakeWithSeconds(second, preferredTimescale: 1)
        do {
            let image = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage.init(cgImage: image)
        } catch  {
            print("error")
        }
        return nil
    }
}

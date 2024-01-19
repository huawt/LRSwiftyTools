import Foundation
import Photos
import AVKit
public extension PHAsset {
    func getNetImage(_ urlString: String) -> UIImage {
        guard let url = URL(string: urlString) else{
            return UIImage()
        }
        let asset = AVURLAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 1)
        var actualTime : CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: 0)
        do {
            let image = try assetImageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            return UIImage.init(cgImage: image)
        } catch  {
            print("error")
        }
        return UIImage()
    }
}

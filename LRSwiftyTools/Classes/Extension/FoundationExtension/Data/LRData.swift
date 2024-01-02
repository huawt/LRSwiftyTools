
import Foundation

public extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)
        
        var ext: String = ".png"
        switch (values[0]) {
        case 0xFF:
            ext = ".jpg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        case 0x52 where self.count >= 12:
            let subdata = self[0...11]
            if let dataString = String(data: subdata, encoding: .ascii),
               dataString.hasPrefix("RIFF"),
               dataString.hasSuffix("WEBP") {
                ext = ".webp"
            }
        case 0x00 where self.count >= 12 :
            let subdata = self[8...11]
            if let dataString = String(data: subdata, encoding: .ascii),
               Set(["heic", "heix", "hevc", "hevx"]).contains(dataString) {
                ext = ".heic"
            }
        default:
            ext = ".png"
        }
        return ext
    }
    
    //将Data转换为String
    var hexString: String {
        return withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: count)
            return buffer.map {String(format: "%02hhx", $0)}.reduce("", { $0 + $1 })
        }
    }
    
    
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}

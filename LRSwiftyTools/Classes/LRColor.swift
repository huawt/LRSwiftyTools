import UIKit
import Foundation
public extension UIColor {
    static func color(by hexString: String) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if hexToRGBA(str: hexString, r: &r, g: &g, b: &b, a: &a) {
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        return nil
    }
    private static func hexToRGBA(str: String, r: inout CGFloat, g: inout CGFloat, b: inout CGFloat, a: inout CGFloat) -> Bool {
        var str = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if str.hasPrefix("#") {
            str = str.subString(from: 1)
        } else if str.hasPrefix("0X") {
            str = str.subString(from: 2)
        }
        let length = str.count
        guard length == 3 || length == 4 || length == 6 || length == 8 else { return false }
        if length < 5 {
            r = CGFloat(hexToInt(str: str.subString(from: 0, to: 1))) / 255.0
            g = CGFloat(hexToInt(str: str.subString(from: 1, to: 2))) / 255.0
            b = CGFloat(hexToInt(str: str.subString(from: 2, to: 3))) / 255.0
            if length == 4 {
                a = CGFloat(hexToInt(str: str.subString(from: 3, to: 4))) / 255.0
            } else {
                a = 1
            }
        } else {
            r = CGFloat(hexToInt(str: str.subString(from: 0, to: 2))) / 255.0
            g = CGFloat(hexToInt(str: str.subString(from: 2, to: 4))) / 255.0
            b = CGFloat(hexToInt(str: str.subString(from: 4, to: 6))) / 255.0
            if length == 8 {
                a = CGFloat(hexToInt(str: str.subString(from: 6, to: 8))) / 255.0
            } else {
                a = 1
            }
        }
        return true
    }
    private static func hexToInt(str: String) -> Int {
        if let decimalNumber = Int(str, radix: 16) {
            return decimalNumber
        } else {
            return 0
        }
    }
}

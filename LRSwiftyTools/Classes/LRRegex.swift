import Foundation
@objc open class LRRegex: NSObject {
    @objc public static func match(pattern: String, matchStr: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: matchStr, options: [], range: NSRange(location: 0, length: matchStr.utf16.count))
        var match: Bool = false
        for result in matches {
            if result.range.location != NSNotFound {
                match = true
                break
            }
        }
        return match
    }
    @objc public static func isEmail(matchStr: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return LRRegex.match(pattern: pattern, matchStr: matchStr)
    }
    @objc public static func isIPAddress(matchStr: String) -> Bool {
        let pattern = "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)"
        return LRRegex.match(pattern: pattern, matchStr: matchStr)
    }
    @objc public static func isNumber(matchStr: String) -> Bool {
        let pattern = "^[0-9]*$"
        return LRRegex.match(pattern: pattern, matchStr: matchStr)
    }
    @objc public static func isAlphabet(matchStr: String) -> Bool {
        let pattern = "^[A-Za-z]+$"
        return LRRegex.match(pattern: pattern, matchStr: matchStr)
    }
    @objc public static func isChinese(matchStr: String) -> Bool {
        let pattern = "[\\u4e00-\\u9fa5]+"
        return LRRegex.match(pattern: pattern, matchStr: matchStr)
    }
}

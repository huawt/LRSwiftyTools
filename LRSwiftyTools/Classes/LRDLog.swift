import Foundation
public func DLog<T>(_ message: T, file : String = #file, line : Int = #line, method: String = #function) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName), line:\(line), func: \(method)]- \(message)")
    #endif
}

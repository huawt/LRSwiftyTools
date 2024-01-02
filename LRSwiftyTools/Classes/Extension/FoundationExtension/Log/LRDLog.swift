
import Foundation

// MARK:Log
public func dPrint(item: @autoclosure () -> Any) {
    #if DEBUG
    print(item())
    #endif
}
public func printLog<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
public func DLog<T>(_ message: T, file : String = #file, lineNumber : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]- \(message)")
    #endif
}

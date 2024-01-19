import Foundation
public extension Double {
    func clipPoint() -> String {
        return NSString(format: "%.f", self) as String
    }
    func clipPoint(last: Int) -> String {
        return String(format: "%.\(last)f", self)
    }
    func clipOnePoint() -> String {
        return clipPoint(last: 1)
    }
}

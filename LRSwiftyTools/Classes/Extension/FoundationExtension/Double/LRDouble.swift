
import Foundation

public extension Double {
    /**
     - returns: 去除小数部分的字符串
     */
    func clipPoint() -> String {
        return NSString(format: "%.f", self) as String
    }
    
    func clipPoint(last: Int) -> String {
        return String(format: "%.\(last)f", self)
    }
    
    /// 一位小数
    func clipOnePoint() -> String {
        return NSString(format: "%.1f", self) as String
    }
    
    /**
     有小数就进位
     - returns: 进位后的整数
     */
    var integerByDecimal: Int {
        let a = Int(self)
        if Double(a) < self {
            return a + 1
        } else {
            return a
        }
    }
    
    var HmsString: String {
        get {
            let temp = self.integerByDecimal
            let seconds = temp % 60
            let mins = ((temp-seconds)/60) % 60
            let hours = (temp-seconds - mins * 60)/3600
            var r = ""
            if hours > 0 {
                if hours < 10 {
                    r += "0\(hours):"
                } else {
                    r += "\(hours):"
                }
            }
            if mins < 10 {
                r += "0\(mins):"
            } else {
                r += "\(mins):"
            }
            if seconds < 10 {
                r += "0\(seconds)"
            } else {
                r += "\(seconds)"
            }
            return r
        }
    }
    
    var msString: String {
        get {
            let temp = self.integerByDecimal
            let seconds = temp % 60
            let mins = (temp-seconds)/60
            var r = ""
            if mins < 10 {
                r += "0\(mins):"
            } else {
                r += "\(mins):"
            }
            if seconds < 10 {
                r += "0\(seconds)"
            } else {
                r += "\(seconds)"
            }
            return r
        }
    }
}

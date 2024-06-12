import Foundation
import UIKit
@objc public extension UIFont {
    class func pingfangRegular(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    class func pingfangLight(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    class func pingfangSemibold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    class func pingfangMedium(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    class func pingfangBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    class func pingfangFont(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFang SC", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

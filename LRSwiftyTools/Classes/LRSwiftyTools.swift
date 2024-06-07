import Foundation
import UIKit
public let LRWidth: CGFloat = UIScreen.main.bounds.width
public let LRHeight: CGFloat = UIScreen.main.bounds.height
public private(set) var LRSafeArea: UIEdgeInsets = .zero
public private(set) var LRTabBarHeight: CGFloat = 49
public private(set) var LRNavigationBarHeight: CGFloat = 44
public private(set) var LRTabbarOffset: CGFloat = 0
public private(set) var LRStatusBarHeight: CGFloat = 20
public private(set) var LRFinalTopHeight: CGFloat = 64
public func LRIsIPhoneX() -> Bool {
    return LRSafeArea.left != 0 || LRSafeArea.bottom != 0
}
public var AppWindow: UIWindow? {
    if #available(iOS 16.0, *) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scene.windows.first {
            return window
        }
    } else  if #available(iOS 11.0, *) {
        if let rootView = UIApplication.shared.delegate?.window as? UIWindow {
            return rootView
        }
    }
    return UIApplication.shared.keyWindow
}
open class LRSwiftyTools: NSObject {
    public class func configureUISize() {
        LRSafeArea = AppWindow?.safeAreaInsets ?? .zero
        if LRIsIPhoneX() {
            LRTabbarOffset = LRSafeArea.bottom
            LRTabBarHeight = 49 + LRTabbarOffset
            LRStatusBarHeight = LRSafeArea.top
            LRFinalTopHeight = LRStatusBarHeight + LRNavigationBarHeight
        } else {
            LRTabbarOffset = 0
            LRTabBarHeight = 49 + LRTabbarOffset
            LRStatusBarHeight = 20
            LRFinalTopHeight = LRStatusBarHeight + LRNavigationBarHeight
        }
    }
}

@propertyWrapper
public struct LrSaved<T> {
    private let key: String
    private let defaultValue: T
    private let defaults = UserDefaults.standard
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    public var wrappedValue: T {
        get {
            return (defaults.object(forKey: key) as? T) ?? defaultValue
        }
        set {
            switch newValue as Any {
            case Optional<Any>.some(let value):
                defaults.set(value, forKey: key)
            case Optional<Any>.none:
                defaults.removeObject(forKey: key)
            default:
                defaults.set(newValue, forKey: key)
            }
            defaults.synchronize()
        }
    }
}

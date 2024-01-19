import Foundation
import UIKit
public let LRWidth: CGFloat = UIScreen.main.bounds.width
public let LRHeight: CGFloat = UIScreen.main.bounds.height
public func LRSafeArea() -> UIEdgeInsets {
    return AppWindow?.safeAreaInsets ?? .zero
}
public var LRTabBarHeight: CGFloat {
    return 49 + LRSafeArea().bottom
}
public var LRNavigationBarHeight: CGFloat {
    return 44
}
public var LRTabbarOffset: CGFloat {
    return LRSafeArea().bottom
}
public var KStatusBarHeight: CGFloat {
    return LRSafeArea().top
}
public var kTopHeight: CGFloat {
    return (LRSafeArea().top + 44)
}
public func kIsIPhoneX() -> Bool {
    return LRSafeArea().left != 0 || LRSafeArea().bottom != 0
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

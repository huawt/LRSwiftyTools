
import Foundation
import UIKit

/// 状态栏高度
public var KStateBarHigh: CGFloat {
    return safeArea().top
}

/// 顶部状态栏+导航高度
public var kTopSpaceHigh: CGFloat {
    return (safeArea().top + 44)
}

/// 底部安全区域的高度
public var kBottomSafeHeight: CGFloat {
    return (safeArea().bottom)
}

public func safeArea() -> UIEdgeInsets {
    if #available(iOS 16.0, *) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scene.windows.first {
            return window.safeAreaInsets
        }
    } else  if #available(iOS 11.0, *) {
        if let rootView = UIApplication.shared.delegate?.window as? UIWindow {
            return rootView.safeAreaInsets
        }
    }
    return .zero
}

public func kIsIPhoneX() -> Bool {
    return safeArea().left != 0 || safeArea().bottom != 0
}

// MARK:Frame
// 以8宽高为基准
public let kWidth: CGFloat = UIScreen.main.bounds.width
public let kHeight: CGFloat = UIScreen.main.bounds.height
public let kScreenB: CGRect = UIScreen.main.bounds
public var kTabBarH: CGFloat {
    return 49 + safeArea().bottom
}
public var kNavigationH: CGFloat {
    return (safeArea().top + 44)
}
public var kTabbarOffset: CGFloat {
    return safeArea().bottom
}
public let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
public let navigationBarHeight: CGFloat = 44.0
public var AppWindow: UIWindow? {
    return UIApplication.shared.keyWindow
    /*
    // 应当该成这样，但是需要测试：
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        // 更准确的：
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    } else {
        return UIApplication.shared.keyWindow
    }
    */
}
//兼容强制横屏后 获取top为0的问题
public let kNativeBoundsHeight = UIScreen.main.nativeBounds.size.height

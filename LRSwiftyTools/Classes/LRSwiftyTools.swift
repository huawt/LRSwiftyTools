//
//  LRSwiftyTools.swift
//  LRSwiftyTools
//
//  Created by huawt on 2022/12/14.
//

import Foundation
import UIKit

public let LRWidth: CGFloat = UIScreen.main.bounds.width
public let LRHeight: CGFloat = UIScreen.main.bounds.height

public func LRSafeArea() -> UIEdgeInsets {
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

public var LRTabBarHeight: CGFloat {
    return 49 + LRSafeArea().bottom
}
public var LRNavigationBarHeight: CGFloat {
    return (LRSafeArea().top + 44)
}
public var LRTabbarOffset: CGFloat {
    return LRSafeArea().bottom
}

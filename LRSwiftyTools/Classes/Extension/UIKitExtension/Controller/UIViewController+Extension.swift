
import Foundation
import UIKit

// Storyboard
public extension UIViewController {
    @objc static func storyBoardId() -> String{
        return String(describing:self)
    }
    
    @objc static func currentViewController() -> UIViewController?{
        var vc = AppWindow?.rootViewController
        while 1 > 0 {
            if vc is UITabBarController {
                vc = (vc as! UITabBarController).selectedViewController
            }
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController
            }
            if let topvc = vc?.presentedViewController{
                vc = topvc
            }else{
                break
            }
        }
        return vc
    }
    
}

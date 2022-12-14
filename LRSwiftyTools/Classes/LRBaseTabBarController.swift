//
//  LRBaseTabBarController.swift
//
//
//  Created by huawt on 2022/11/9.
//

import UIKit
import Foundation
import QuartzCore

public enum LRTabBarItemAnimationType: Int {
    case none
    case gravity
    case zoomInout
    case zAxisRotation
    case yAxisJump
}

public class LRBaseTabBarController: UITabBarController, UITabBarControllerDelegate {

    private let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 212.0 / 255.0, alpha: 1.0)]
    private let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 236/255.0, green: 95/255.0, blue: 177/255.0, alpha: 1.0)]
    
    
    var reSelectHandler:((_ index: Int)->Void)?
    
    private lazy var imageViews: [UIImageView] = {
        var views: [UIImageView] = []
        var buttonss: [UIControl] = []
        self.tabBar.subviews.forEach { sub in
            if let sub = sub as? UIControl {
                buttonss.append(sub)
            }
        }
        for button in buttonss {
            button.subviews.forEach { subView in
                if let sub = subView as? UIImageView {
                    views.append(sub)
                }
            }
        }
        return views
    }()
    var itemAniamtionType: LRTabBarItemAnimationType = .none
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.tabBar.barStyle = .default
        self.tabBar.isOpaque = false
        self.tabBar.isTranslucent = false
        self.delegate = self
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            self.configAppearance(appearance.stackedLayoutAppearance)
            self.configAppearance(appearance.inlineLayoutAppearance)
            self.configAppearance(appearance.compactInlineLayoutAppearance)
            appearance.shadowImage = UIImage.image(color: UIColor.clear)
            appearance.backgroundImage = UIImage.image(color: UIColor.white)
            appearance.backgroundColor = UIColor.white
            self.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                self.tabBar.scrollEdgeAppearance = appearance
            }
            self.tabBar.standardAppearance.backgroundColor = UIColor.white
        } else {
            self.tabBar.backgroundColor = UIColor.white
            UITabBarItem.appearance().setTitleTextAttributes(normal, for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes(selected, for: .selected)
            self.tabBar.backgroundImage = UIImage.image(color: .clear, size: CGSize(width: LRWidth, height: LRTabBarHeight))
            self.tabBar.shadowImage = UIImage.image(color: .clear)
        }
        
    }
    
    @available(iOS 13.0, *)
    private func configAppearance(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.titleTextAttributes = normal
        itemAppearance.selected.titleTextAttributes = selected
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index != NSNotFound {
            self.animate(index: index)
        }
        return true
    }
    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item), index != NSNotFound, self.selectedIndex == index else { return }
        self.reSelectHandler?(index)
    }
    
    private func animate(index: Int) {
        guard self.itemAniamtionType != .none else { return }
        guard self.imageViews.isEmpty == false else { return }
        guard index < self.imageViews.count else { return }
        let imageView = self.imageViews[index]
        switch self.itemAniamtionType {
        case .gravity:
            AnimationTool.gravity(view: imageView)
        case .zoomInout:
            AnimationTool.zoomInout(view: imageView)
        case .zAxisRotation:
            AnimationTool.zAxisRotation(view: imageView)
        case .yAxisJump:
            AnimationTool.yAxisJump(view: imageView)
        default: break;
        }
    }
}

class AnimationTool {
    class func gravity(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.values = [0.0, -4.15, -7.26, -9.34, -10.37, -9.34, -7.26, -4.15, 0.0, 2.0, -2.9, -4.94, -6.11, -6.42, -5.86, -4.44, -2.16, 0.0]
        animation.duration = 0.55
        animation.beginTime = CACurrentMediaTime() + 0.25
        view.layer.add(animation, forKey: nil)
    }
    class func zoomInout(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        animation.duration = 0.6
        animation.calculationMode = CAAnimationCalculationMode.cubic
        view.layer.add(animation, forKey: nil)
    }
    class func zAxisRotation(view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        animation.fromValue = 0
        animation.toValue = CGFloat.pi
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(animation, forKey: nil)
    }
    class func yAxisJump(view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        animation.fromValue = 0
        animation.toValue = -10
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(animation, forKey: nil)
    }
}

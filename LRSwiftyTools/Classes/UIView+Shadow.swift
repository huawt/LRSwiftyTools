//
//  UIView+Shadow.swift
//  
//
//  Created by huawt on 2022/8/4.
//

import Foundation
import UIKit

extension UIView {
    public func shadow(color: UIColor = UIColor.black.withAlphaComponent(0.5), offset: CGSize = CGSize(width: 0, height: 1), opacity: CGFloat = 1, radius: CGFloat = 2) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = radius
    }
    public func removeAllSubviews() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

extension UIImage {
    public class func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

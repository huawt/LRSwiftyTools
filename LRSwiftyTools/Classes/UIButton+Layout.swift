//
//  UIButton+Layout.swift
//  
//
//  Created by WinTer on 2022/6/7.
//

import Foundation
import UIKit

open class UILayoutButton: UIButton {
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.resetLayoutStyle()
    }
}

public enum UIButtonLayoutStyle: Int {
    case leftImageRightTitle = 0
    case leftTitleRightImage
    case upImageDownTitle
    case upTitleDownImage
}

extension UIButton {
    private struct _AssociatedKeys {
        static var spacingKey = "spacingKey"
        static var styleKey = "styleKey"
    }
    
    public var spacing: CGFloat {
        get {
            return objc_getAssociatedObject(self, &_AssociatedKeys.spacingKey) as? CGFloat ?? 2
        }
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.spacingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var layoutStyle: UIButtonLayoutStyle {
        get {
            return objc_getAssociatedObject(self, &_AssociatedKeys.styleKey) as? UIButtonLayoutStyle ?? .leftImageRightTitle
        }
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.styleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC )
        }
    }
    
    public func resetLayoutStyle() {
        guard let image = self.imageView, let title = self.titleLabel else { return }
        image.sizeToFit()
        title.sizeToFit()
        switch self.layoutStyle {
        case .leftImageRightTitle:
            self.layoutHorizontal(leftView: image, rightView: title, spacing: self.spacing)
        case .leftTitleRightImage:
            self.layoutHorizontal(leftView: title, rightView: image, spacing: self.spacing)
        case .upImageDownTitle:
            self.layoutVertical(upView: image, downView: title, spacing: self.spacing)
        case .upTitleDownImage:
            self.layoutVertical(upView: title, downView: image, spacing: self.spacing)
        }
    }

    func layoutHorizontal(leftView: UIView, rightView: UIView, spacing: CGFloat) {
        var leftFrame = leftView.frame
        var rightFrame = rightView.frame
        let totalWidth = leftFrame.width + spacing + rightFrame.width

        leftFrame.origin.x = (self.bounds.width - totalWidth) / 2.0
        leftFrame.origin.y = (self.bounds.height - leftFrame.height ) / 2.0
        leftView.frame = leftFrame

        rightFrame.origin.x = leftFrame.maxX + spacing
        rightFrame.origin.y = (self.bounds.height - rightFrame.height) / 2.0
        rightView.frame = rightFrame
    }

    func layoutVertical(upView: UIView, downView: UIView, spacing: CGFloat) {
        var upFrame = upView.frame
        var downFrame = downView.frame

        let totalHeight = upFrame.height + spacing + downFrame.height

        upFrame.origin.y = (self.bounds.height - totalHeight) / 2.0
        upFrame.origin.x = (self.bounds.width - upFrame.width) / 2.0
        upView.frame = upFrame

        downFrame.origin.y = upFrame.maxY + spacing
        downFrame.origin.x = (self.bounds.width - downFrame.width) / 2.0
        downView.frame = downFrame
    }
}

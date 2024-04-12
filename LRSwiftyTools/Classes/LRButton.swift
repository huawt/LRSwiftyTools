import Foundation
import UIKit
@objcMembers
open class UILayoutButton: UIButton {
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.resetLayoutStyle()
    }
}
@objc public enum UIButtonLayoutStyle: Int {
    case leftImageRightTitle = 0
    case leftTitleRightImage
    case upImageDownTitle
    case upTitleDownImage
}
@objc extension UIButton {
    private struct _AssociatedKeys {
        static var spacingKey = "spacingKey"
        static var styleKey = "styleKey"
    }
    @objc @IBInspectable public var spacing: CGFloat {
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
    @objc @IBInspectable var layoutStyleNumber: Int {
        set {
            self.layoutStyle = UIButtonLayoutStyle(rawValue: newValue) ?? .leftImageRightTitle
        }
        get {
            return self.layoutStyle.rawValue
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
        var leftFrame = leftView.isHidden ? CGRect.zero : leftView.frame
        var rightFrame = rightView.isHidden ? CGRect.zero : rightView.frame
        let spacing = (leftView.isHidden || rightView.isHidden) ? 0 : spacing
        let totalWidth = leftFrame.width + spacing + rightFrame.width
        switch self.contentHorizontalAlignment {
        case .left, .leading:
            leftFrame.origin.x = 0
            rightFrame.origin.x = leftFrame.maxX + spacing
        case .center, .fill:
            leftFrame.origin.x = (self.bounds.width - totalWidth) / 2.0
            rightFrame.origin.x = leftFrame.maxX + spacing
        case .right, .trailing:
            rightFrame.origin.x = self.bounds.width - rightFrame.width
            leftFrame.origin.x = rightFrame.minX - spacing - leftFrame.width
        @unknown default:
            leftFrame.origin.x = (self.bounds.width - totalWidth) / 2.0
            rightFrame.origin.x = leftFrame.maxX + spacing
        }
        switch self.contentVerticalAlignment {
        case .top:
            leftFrame.origin.y = 0
            rightFrame.origin.y = 0
        case .center, .fill:
            leftFrame.origin.y = (self.bounds.height - leftFrame.height ) / 2.0
            rightFrame.origin.y = (self.bounds.height - rightFrame.height) / 2.0
        case .bottom:
            leftFrame.origin.y = self.bounds.height - leftFrame.height
            rightFrame.origin.y = self.bounds.height - rightFrame.height
        @unknown default:
            leftFrame.origin.y = (self.bounds.height - leftFrame.height ) / 2.0
            rightFrame.origin.y = (self.bounds.height - rightFrame.height) / 2.0
        }
        leftView.frame = leftFrame
        rightView.frame = rightFrame
    }
    func layoutVertical(upView: UIView, downView: UIView, spacing: CGFloat) {
        var upFrame = upView.isHidden ? CGRect.zero : upView.frame
        var downFrame = downView.isHidden ? CGRect.zero : downView.frame
        let spacing = (upView.isHidden || downView.isHidden) ? 0 : spacing
        let totalHeight = upFrame.height + spacing + downFrame.height
        switch self.contentHorizontalAlignment {
        case .left, .leading:
            upFrame.origin.x = 0
            downFrame.origin.x = 0
        case .center, .fill:
            upFrame.origin.x = (self.bounds.width - upFrame.width) / 2.0
            downFrame.origin.x = (self.bounds.width - downFrame.width) / 2.0
        case .right, .trailing:
            upFrame.origin.x = self.bounds.width - upFrame.width
            downFrame.origin.x = self.bounds.width - downFrame.width
        @unknown default:
            upFrame.origin.x = (self.bounds.width - upFrame.width) / 2.0
            downFrame.origin.x = (self.bounds.width - downFrame.width) / 2.0
        }
        switch self.contentVerticalAlignment {
        case .top:
            upFrame.origin.y = 0
            downFrame.origin.y = upFrame.maxY + spacing
        case .center, .fill:
            upFrame.origin.y = (self.bounds.height - totalHeight) / 2.0
            downFrame.origin.y = upFrame.maxY + spacing
        case .bottom:
            downFrame.origin.y = self.bounds.height - downFrame.height
            upFrame.origin.y = downFrame.minY - spacing - upFrame.height
        @unknown default:
            upFrame.origin.y = (self.bounds.height - totalHeight) / 2.0
            downFrame.origin.y = upFrame.maxY + spacing
        }
        upView.frame = upFrame
        downView.frame = downFrame
    }
}

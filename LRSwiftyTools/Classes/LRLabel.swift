
import Foundation
import UIKit

@objc extension UILabel {
    struct AssociatedKeys {
        static var lineSpacingKey = "lineSpacingKey"
    }
    @objc @IBInspectable open var lineSpace: CGFloat {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lineSpacingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.lineSpacingKey) as? CGFloat) ?? 0
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard self.lineSpace > 0, let text = self.text, text.isEmpty == false else { return }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = self.lineSpace
        style.alignment = self.textAlignment
        self.attributedText = NSAttributedString(string: text, attributes: [.font: self.font as Any, .foregroundColor: self.textColor as Any, .paragraphStyle: style])
    }
}

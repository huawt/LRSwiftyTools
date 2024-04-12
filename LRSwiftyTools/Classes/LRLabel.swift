
import Foundation
import UIKit

@objc extension UILabel {
    struct AssociatedKeys {
        static var lineSpacingKey = "textSpacingKey"
    }
    @objc @IBInspectable var lineSpacing: CGFloat {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lineSpacingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.lineSpacingKey) as? CGFloat) ?? 0
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard lineSpacing > 0, let text = text, text.isEmpty == false else { return }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = self.textAlignment
        self.attributedText = NSAttributedString(string: text, attributes: [.font: self.font as Any, .foregroundColor: self.textColor as Any, .paragraphStyle: style])
    }
}

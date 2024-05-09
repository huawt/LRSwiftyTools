import UIKit
@objc public extension UIView {
    @objc func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let size = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    @objc @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @objc @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @objc @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    @objc var viewController: UIViewController? {
        var responder: UIResponder = self
        while let next = responder.next {
            if let vc = next as? UIViewController {
                return vc
            }
            responder = next
        }
        return nil
    }
    @objc func removeALLSubviews() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

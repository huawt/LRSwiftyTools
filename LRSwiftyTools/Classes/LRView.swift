import UIKit
@objc public extension UIView {
    @objc func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let size = CGSize(width: radius, height: radius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    @objc func addShadow(_ color: UIColor = UIColor.black, radius: CGFloat = 4, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
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
    @objc @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOffset = CGSize.zero
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowRadius = newValue
        }
    }
}
@objc public extension UIView {
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
}
@objc extension UIView {
    @objc public func shadow(color: UIColor = UIColor.black.withAlphaComponent(0.5), offset: CGSize = CGSize(width: 0, height: 1), opacity: CGFloat = 1, radius: CGFloat = 2) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = radius
    }
    @objc public func removeALLSubviews() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

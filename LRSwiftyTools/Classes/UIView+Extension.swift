import UIKit
public extension UIView {
	func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let size = CGSize(width: radius, height: radius)
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size)
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape
	}
	func addShadow(_ color: UIColor = UIColor.black, radius: CGFloat = 4, offset: CGSize = .zero, opacity: Float = 0.5) {
		layer.shadowColor = color.cgColor
		layer.shadowOffset = offset
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		layer.masksToBounds = false
	}
	@IBInspectable var cornerRadius: CGFloat {
	  get {
	   return layer.cornerRadius
	  }
	  set {
	   layer.cornerRadius = newValue
	   layer.masksToBounds = newValue > 0
	  }
	 }
	 @IBInspectable var borderWidth: CGFloat {
	  get {
	   return layer.borderWidth
	  }
	  set {
	   layer.borderWidth = newValue
	   layer.masksToBounds = newValue > 0
	  }
	 }
	 @IBInspectable var borderColor: UIColor {
	  get {
	   return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
	  }
	  set {
	   layer.borderColor = newValue.cgColor
	  }
	 }
		var shadowRadius: CGFloat {
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
public extension UIView {
	var viewController: UIViewController? {
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

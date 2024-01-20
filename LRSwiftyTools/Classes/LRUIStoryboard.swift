import Foundation
import UIKit
public extension UIStoryboard {
	func viewController<T: UIViewController>(with identifier: String? = nil, for type: T.Type = T.self) -> T {
		let loadIdentifier = identifier ?? type.identifier
		return instantiateViewController(withIdentifier: loadIdentifier) as! T
	}
	func initialViewController<T: UIViewController>() -> T {
		return instantiateInitialViewController() as! T
	}
}
public extension UINib {
    func nibView<T: UIView>() -> T {
        return instantiate(withOwner: T.self).first as! T
    }
}
public extension String {
    func viewController<T: UIViewController>() -> T {
        return UIStoryboard(name: self, bundle: nil).viewController()
    }
    func view<T: UIView>() -> T {
        return UINib(nibName: self, bundle: nil).nibView()
    }
}
public extension CGRect {
	func multiBy(scale: CGFloat, holdCenter: Bool = false) -> CGRect {
		let newWidth = self.width * scale
		let newHeight = self.height * scale
		if holdCenter {
			return CGRect(x: self.origin.x, y: self.origin.y, width: newWidth, height: newHeight)
		} else {
			let newX = self.origin.x + (self.width - newWidth) / 2.0
			let newY = self.origin.y + (self.height - newHeight) / 2.0
			return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
		}
	}
}

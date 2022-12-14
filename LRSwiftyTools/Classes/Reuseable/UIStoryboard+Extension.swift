

import Foundation
import UIKit

extension UIStoryboard {
	/// Instantiate a UIViewController using its identifier
	///
	/// - Parameters:
	///   - identifier: identifier: UIViewController identifier
	///   - type: UIController Type
	/// - Returns: The view controller corresponding to specified class name
	func viewController<T: UIViewController>(with identifier: String? = nil, for type: T.Type = T.self) -> T {
		let loadIdentifier = identifier ?? type.identifier
		return instantiateViewController(withIdentifier: loadIdentifier) as! T
	}

	/// SwifterSwift: Instantiate a Initial UIViewController
	///
	/// - Returns: The view controller corresponding to specified class name
	func initialViewController<T: UIViewController>() -> T {
		return instantiateInitialViewController() as! T
	}
}

extension UINib {
    func nibView<T: UIView>() -> T {
        return instantiate(withOwner: T.self).first as! T
    }
}

extension String {
    func viewController<T: UIViewController>() -> T {
        return UIStoryboard(name: self, bundle: nil).viewController()
    }
    func view<T: UIView>() -> T {
        return UINib(nibName: self, bundle: nil).nibView()
    }
}



extension CGRect {
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

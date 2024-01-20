import UIKit
public extension UITableView {
	func registerCell<T: UITableViewCell>(_ type: T.Type, withIdentifier reuseIdentifier: String = String(describing: T.self)) {
		register(T.self, forCellReuseIdentifier: reuseIdentifier)
	}
	func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
			fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
		}
		return cell
	}
	func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self), for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
			fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
		}
		return cell
	}
	func registerSection<T: UITableViewHeaderFooterView>(_ type: T.Type, with reuseIdentifier: String = T.identifier) {
		register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
	}
	func dequeueSection<T: UITableViewHeaderFooterView>(reuseIdentifier: String = T.identifier) -> T {
		guard let section = dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T else {
			fatalError("Unknown section type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
		}
		return section
	}
}

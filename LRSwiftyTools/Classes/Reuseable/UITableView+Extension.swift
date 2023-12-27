
import UIKit

public extension UITableView {
	/**
	 Registers a UITableViewCell for use in a UITableView.

	 - parameter type: The type of cell to register.
	 - parameter reuseIdentifier: The reuse identifier for the cell (optional).

	 By default, the class name of the cell is used as the reuse identifier.

	 Example:
	 ```
	 class CustomCell: UITableViewCell {}

	 let tableView = UITableView()

	 // registers the CustomCell class with a reuse identifier of "CustomCell"
	 tableView.registerCell(CustomCell)
	 ```
	 */
	func registerCell<T: UITableViewCell>(_ type: T.Type, withIdentifier reuseIdentifier: String = String(describing: T.self)) {
		register(T.self, forCellReuseIdentifier: reuseIdentifier)
	}

	/**
	 Dequeues a UITableViewCell for use in a UITableView.

	 - parameter type: The type of the cell.
	 - parameter reuseIdentifier: The reuse identifier for the cell (optional).

	 - returns: A force-casted UITableViewCell of the specified type.

	 By default, the class name of the cell is used as the reuse identifier.

	 Example:
	 ```
	 class CustomCell: UITableViewCell {}

	 let tableView = UITableView()

	 // dequeues a CustomCell class
	 let cell = tableView.dequeueReusableCell(CustomCell)
	 ```
	 */
	func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self)) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
			fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
		}
		return cell
	}

	/**
	 Dequeues a UITableViewCell for use in a UITableView.

	 - parameter type: The type of the cell.
	 - parameter indexPath: The index path at which to dequeue a new cell.
	 - parameter reuseIdentifier: The reuse identifier for the cell (optional).

	 - returns: A force-casted UITableViewCell of the specified type.

	 By default, the class name of the cell is used as the reuse identifier.

	 Example:
	 ```
	 class CustomCell: UITableViewCell {}

	 let tableView = UITableView()

	 // dequeues a CustomCell class
	 let cell = tableView.dequeueReusableCell(CustomCell.self, forIndexPath: indexPath)
	 ```
	 */
	func dequeueCell<T: UITableViewCell>(_ type: T.Type = T.self, withIdentifier reuseIdentifier: String = String(describing: T.self), for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
			fatalError("Unknown cell type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
		}
		return cell
	}

	/**
	 Registers a UITableViewHeaderFooterView for use in a UITableView.

	 - parameter type: The type of header of footer to register.
	 - parameter reuseIdentifier: The reuse identifier for the header (optional).

	 By default, the class name of the cell is used as the reuse identifier.

	 Example:
	 ```
	 class CustomHeader: UITableViewHeaderFooterView {}

	 let tableView = UITableView()

	 // registers the CustomCell class with a reuse identifier of "CustomHeader"
	 tableView.registerSection(CustomHeader)
	 ```
	 */
	func registerSection<T: UITableViewHeaderFooterView>(_ type: T.Type, with reuseIdentifier: String = T.identifier) {
		register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
	}

	/**
	 Dequeues a UITableViewHeaderFooterView for use in a UITableView.

	 - parameter reuseIdentifier: The reuse identifier for the header (optional).

	 - returns: A force-casted UITableViewHeaderFooterView of the specified type.

	 By default, the class name of the cell is used as the reuse identifier.

	 Example:
	 ```
	 class CustomHeader: UITableViewHeaderFooterView {}

	 let tableView = UITableView()

	 // dequeues a CustomHeader class
	 let header = tableView.dequeueReusableCell(CustomHeader)
	 ```
	 */
	func dequeueSection<T: UITableViewHeaderFooterView>(reuseIdentifier: String = T.identifier) -> T {
		guard let section = dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T else {
			fatalError("Unknown section type (\(T.self)) for reuse identifier: \(reuseIdentifier)")
		}
		return section
	}
}

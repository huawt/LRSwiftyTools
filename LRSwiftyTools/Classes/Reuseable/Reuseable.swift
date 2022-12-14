

import UIKit

public protocol Reuseable {
    static var identifier: String { get }
}

extension Reuseable {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reuseable {}

extension UICollectionReusableView: Reuseable {}

extension UIViewController: Reuseable {}

extension UITableViewHeaderFooterView: Reuseable {}

extension UIView: Reuseable {}



import Foundation
import UIKit

// MARK: - Methods
public extension UICollectionView {
    /// SwifterSwift: Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0,
                       animations: {
                        self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    /// SwifterSwift: Dequeue reusable UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - type: UICollectionViewCell type.
    ///   - identifier: The reuse identifier for the cell (optional).
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionViewCell object with associated class name.
    func dequeueCell<T: UICollectionViewCell>(type: T.Type = T.self, identifier: String? = nil, at indexPath: IndexPath) -> T {
        let reuseIdentifier = identifier ?? type.identifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find \(type) for \(reuseIdentifier)")
        }
        return cell
    }

    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the collectionView cell (optional).
    ///   - type: UICollectionViewCell type.
    ///   - identifier: The reuse identifier for the cell.
    func registerCell<T: UICollectionViewCell>(nib: UINib? = nil, type: T.Type, identifier: String? = nil) {
        let reuseIdentifier = identifier ?? type.identifier
        if let nib = nib {
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(type, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }

    /// SwifterSwift: Dequeue reusable UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - type: UICollectionReusableView type.
    ///   - identifier: The reuse identifier for the supplementary view (optional).
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionReusableView object with associated class name.
    func dequeueSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, type: T.Type = T.self, identifier: String? = nil, at indexPath: IndexPath) -> T {
        let reuseIdentifier = identifier ?? type.identifier
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find \(type) for \(reuseIdentifier)")
        }
        return cell
    }

    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the reusable view (optional).
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - type: UICollectionReusableView type.
    ///   - identifier: The reuse identifier for the supplementary view.
    func registerSupplementaryView<T: UICollectionReusableView>(nib: UINib? = nil, ofKind kind: String, type: T.Type, identifier: String? = nil) {
        let reuseIdentifier = identifier ?? type.identifier
        if let nib = nib {
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        } else {
            register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        }
    }

    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the reusable view (optional).
    ///   - type: UICollectionReusableView type.
    ///   - identifier: The reuse identifier for the decoration view.
    func registerDecorationView<T: UICollectionReusableView>(nib: UINib? = nil, type: T.Type, identifier: String? = nil) {
        let reuseIdentifier = identifier ?? type.identifier
        if let nib = nib {
            collectionViewLayout.register(nib, forDecorationViewOfKind: reuseIdentifier)
        } else {
            collectionViewLayout.register(type, forDecorationViewOfKind: reuseIdentifier)
        }
    }
}

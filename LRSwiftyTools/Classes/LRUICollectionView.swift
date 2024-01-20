import Foundation
import UIKit
public extension UICollectionView {
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0,
                       animations: {
                        self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    func dequeueCell<T: UICollectionViewCell>(type: T.Type = T.self, identifier: String? = nil, at indexPath: IndexPath) -> T {
        let reuseIdentifier = identifier ?? type.identifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find \(type) for \(reuseIdentifier)")
        }
        return cell
    }
    func registerCell<T: UICollectionViewCell>(nib: UINib? = nil, type: T.Type, identifier: String? = nil) {
        let reuseIdentifier = identifier ?? type.identifier
        if let nib = nib {
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(type, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    func dequeueSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, type: T.Type = T.self, identifier: String? = nil, at indexPath: IndexPath) -> T {
        let reuseIdentifier = identifier ?? type.identifier
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't find \(type) for \(reuseIdentifier)")
        }
        return cell
    }
    func registerSupplementaryView<T: UICollectionReusableView>(nib: UINib? = nil, ofKind kind: String, type: T.Type, identifier: String? = nil) {
        let reuseIdentifier = identifier ?? type.identifier
        if let nib = nib {
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        } else {
            register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
        }
    }
    func registerDecorationView<T: UICollectionReusableView>(nib: UINib? = nil, type: T.Type, identifier: String? = nil) {
        let reuseIdentifier = identifier ?? type.identifier
        if let nib = nib {
            collectionViewLayout.register(nib, forDecorationViewOfKind: reuseIdentifier)
        } else {
            collectionViewLayout.register(type, forDecorationViewOfKind: reuseIdentifier)
        }
    }
}

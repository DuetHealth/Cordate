import Foundation
import UIKit

extension UICollectionView {

    func register<Cell: UICollectionViewCell>(_ type: Cell.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type))
    }

    func dequeue<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
    }

    func cell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell? {
        return cellForItem(at: indexPath) as? Cell
    }

}


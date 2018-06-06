import Foundation
import UIKit

public class CalendarLayout: UICollectionViewFlowLayout {

    public enum AnimationStyle {
        case simple
        case detailed
    }

    public var animationStyle = AnimationStyle.detailed

    private var lastComponent = CalendarDataSource.Component?.none

    func setLayoutProperties(for component: CalendarDataSource.Component) {
        guard let collectionView = collectionView, collectionView.bounds.width > 0 && collectionView.bounds.height > 0 else { return }
        lastComponent = component
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        switch component {
        case .year:
            sectionInset = UIEdgeInsets(top: 0, left: floor(width / 6), bottom: 0, right: floor(width / 6))
            itemSize = CGSize(width: 2 * floor(width / 3), height: floor(height / 5))
        case .month:
            sectionInset = .zero
            minimumInteritemSpacing = 8
            minimumLineSpacing = 8
            itemSize = CGSize(width: (width - 16) / 3, height: (height - 24) / 4)
        case .day:
            sectionInset = .zero
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            itemSize = CGSize(width: floor(width / 7), height: floor(width / 7))

        }
    }

}

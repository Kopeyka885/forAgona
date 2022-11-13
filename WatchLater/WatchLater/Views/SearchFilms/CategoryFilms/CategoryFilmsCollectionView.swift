//
//  CategoryFilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 09.11.2022.
//

import UIKit

class CategoryFilmsCollectionView: SearchFilmsCollectionView {
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width / 3 - 10, height: (width / 3 - 10) * 2.1)
    }
}

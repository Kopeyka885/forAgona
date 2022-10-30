//
//  SearchFilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 22.10.2022.
//

import UIKit

class SearchFilmsCollectionView: FilmsCollectionView {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 110, height: 210)
        }
}

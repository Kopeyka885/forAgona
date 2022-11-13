//
//  SearchFilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 22.10.2022.
//

import UIKit
import Kingfisher

class SearchFilmsCollectionView: FilmsCollectionView {
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
            CGSize(width: 110, height: 210)
        }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == cells.count - 1 {
            reachedLastRow?()
        }
        
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: FilmCollectionViewCell.reuseID,
            for: indexPath
        ) as? FilmCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.title.text = cells[indexPath.row].title
        cell.ratingView.label.text = cells[indexPath.row].rating?.description ?? "-"
        
        let url = URL(string: cells[indexPath.row].posterId ?? "")!
        ImageCache.default.retrieveImage(
            forKey: cells[indexPath.row].title,
            options: nil,
            completionHandler: { image, cacheType in
                if let image = image {
                    cell.imageView.image = image
                } else {
                    cell.imageView.kf.setImage(
                        with: url,
                        completionHandler: { image, error, cacheType, imageURL in
                            if let error = error {
                                print(error)
                            }
                            if let image = image {
                                ImageCache.default.store(image, forKey: self.cells[indexPath.row].title)
                            }
                        })
                }
            })
        return cell
    }
}

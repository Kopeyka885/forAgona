//
//  FilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Kingfisher

class FilmsCollectionView: UICollectionView {
    var cells = [Film]()
    var reachedLastRow: (() -> Void)?
    var showCell: ((_ cell: FilmCollectionViewCell, _ posterId: String, _ index: IndexPath) -> Void)?
    
    init(isVertical: Bool = true, reachedLastRow: @escaping (() -> Void)) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = isVertical ? .vertical : .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        backgroundColor = Asset.lightGray.color
        self.reachedLastRow = reachedLastRow
        register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.reuseID)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilmsCollectionView: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return cells.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            if let posterId = cells[indexPath.row].posterId {
                showCell?(cell, posterId, indexPath)
            }
            return cell
        }
}

extension FilmsCollectionView: FilmsCollectable {
    func addFilms(films: [Film]) {
        cells.append(contentsOf: films)
        let indexPaths = Array((cells.count - films.count) ..< cells.count).map({ IndexPath(row: $0, section: 0) })
        self.insertItems(at: indexPaths)
    }
}

extension FilmsCollectionView: UICollectionViewDelegate {}

extension FilmsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width / 3 - 10, height: (width / 3 - 10) * 2.1)
    }
}

//
//  FilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class FilmsCollectionView: UICollectionView {
    
    private var filmsPosters = [Int: Data?]()
    private var cells = [Film]()
    var reachedLastRow: (() -> Void)?
    
    init(reachedLastRow: @escaping (() -> Void)) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setDelegate()
        setDataSource()
        backgroundColor = .white
        self.reachedLastRow = reachedLastRow
        register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.reuseID)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilmsCollectionView: UICollectionViewDataSource {
    private func setDataSource() {
        dataSource = self
    }
    
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
            cell.imageView.image = nil
            
            let filmId = cells[indexPath.row].id
            if let posterData = filmsPosters[filmId], let posterData = posterData {
                cell.imageView.image = UIImage(data: posterData)
            }
            
            return cell
        }
}

extension FilmsCollectionView: FilmsCollectable {
    func addFilms(films: [Film]) {
        cells.append(contentsOf: films)
    }
    func addPostersData(postersData: [Int: Data?]) {
        filmsPosters.merge(postersData) { data1, _ in return data1 }
    }
}

extension FilmsCollectionView: UICollectionViewDelegate {
    private func setDelegate() {
        delegate = self
    }
}

extension FilmsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width
            return CGSize(width: width / 3 - 10, height: (width / 3 - 10) * 2.1)
        }
}

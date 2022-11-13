//
//  SearchFilmsTableView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 30.10.2022.
//

import UIKit
import Kingfisher

class SearchFilmsTableView: UITableView {
    
    var cells = [Film]()
    
    init() {
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        backgroundColor = Asset.lightGray.color
        register(SearchFilmsTableViewCell.self, forCellReuseIdentifier: SearchFilmsTableViewCell.reuseID)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchFilmsTableView: UITableViewDelegate {}

extension SearchFilmsTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: SearchFilmsTableViewCell.reuseID, for: indexPath) as? SearchFilmsTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.title.text = cells[indexPath.row].title
        let url = URL(string: cells[indexPath.row].posterId ?? "")!
        ImageCache.default.retrieveImage(
            forKey: cells[indexPath.row].title,
            options: nil,
            completionHandler: { image, cacheType in
                if let image = image {
                    cell.image.image = image
                } else {
                    cell.image.kf.setImage(
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

extension SearchFilmsTableView: FilmsCollectable {
    func addFilms(films: [Film]) {
        cells.append(contentsOf: films)
        let indexPaths = Array((cells.count - films.count) ..< cells.count).map({ IndexPath(row: $0, section: 0) })
        self.insertRows(at: indexPaths, with: .automatic)
    }
}

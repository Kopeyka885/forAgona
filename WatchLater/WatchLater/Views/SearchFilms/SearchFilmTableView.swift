//
//  SearchFilmTableView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 30.10.2022.
//

import UIKit

class SearchFilmTableView: UITableView {
    
    var cells = [Film]()
    var imageData = [Int: Data]()
    
    init() {
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        backgroundColor = .white
        register(SearchFilmTableViewCell.self, forCellReuseIdentifier: SearchFilmTableViewCell.reuseID)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchFilmTableView: UITableViewDelegate {}

extension SearchFilmTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: SearchFilmTableViewCell.reuseID, for: indexPath) as? SearchFilmTableViewCell
        else {
            return UITableViewCell()
        }
        
        let imageDataIndex = cells[indexPath.row].id
        cell.image.image = UIImage(data: imageData[imageDataIndex] ?? Data())
        cell.title.text = cells[indexPath.row].title
        
        return cell
    }
}

extension SearchFilmTableView: FilmsCollectable {
    func addFilms(films: [Film]) {
        cells.append(contentsOf: films)
    }
    
    func addPostersData(postersData: [Int: Data]) {
        imageData.merge(postersData) { data1, data2 in
            return data1
        }
    }
}

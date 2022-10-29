//
//  FilmTableView.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 18.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class FilmTableView: UITableView {
    private let reuseID = "FilmTableViewCell"
    private var cells = [Film]()
    var reachedLastRow: (() -> Void)?
    
    init(reachedLastRow: @escaping (() -> Void)) {
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        self.reachedLastRow = reachedLastRow
        register(UITableViewCell.self, forCellReuseIdentifier: self.reuseID)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilmTableView: UITableViewDelegate {}

extension FilmTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == cells.count - 1 {
            reachedLastRow?()
        }
        
        let cell = dequeueReusableCell(
            withIdentifier: self.reuseID,
            for: indexPath
        ) as UITableViewCell
        
        cell.textLabel?.text = cells[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension FilmTableView: FilmsCollectable {
    func addFilms(films: [Film]) {
        self.cells.append(contentsOf: films)
    }
    
    func addPostersData(postersData: [Int: Data?]) {
        print("")
    }
}

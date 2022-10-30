//
//  Film.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved
//

import Foundation

protocol FilmsCollectable {
    func addFilms(films: [Film])
    func addPostersData(postersData: [Int: Data?])
    func reloadData()
}

struct Film {
    let id: Int
    let title: String
    let posterId: String?
    let description: String?
    let genres: [String]?
    let rating: Float?
    let date: String?
}

struct SystemFilm: Codable {
    var id: Int
    var title: String
    let posterId: String?
    let description: String
    let genres: [String]
    let rating: Float?
    let timestamp: String?
}

struct ImdbFilm: Codable {
    let id: String
    let rank: String
    let title: String
    let year: String
    let image: String
    let imDbRating: String
}

struct ImdbSearchItem: Codable {
    let id: String
    let title: String
    let image: String
    let description: String
}

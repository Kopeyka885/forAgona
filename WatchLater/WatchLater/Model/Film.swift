//
//  Film.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved
//

import Foundation

struct Film: Codable {
    let id: Int
    let posterId: String?
    let title: String
    let description: String
    let genres: [String]
    let rating: Float?
    let timestamp: String?
}

struct ImdbFilm: Codable {
    let posterPath: String
    let releaseDate: String
    let title: String
}

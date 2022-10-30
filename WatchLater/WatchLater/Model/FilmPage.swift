//
//  FilmPage.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 08.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

struct SystemFilmPage: Codable {
    let filmDtos: [SystemFilm]
    let pageCount: Int
    let size: Int
    let status: String
}

struct ImdbFilmPage: Codable {
    let items: [ImdbFilm]
    let errorMessage: String?
}

struct ImdbSearchResult: Codable {
    let results: [ImdbSearchItem]
    let errorMessage: String?
}

//
//  FilmPage.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 08.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

struct FilmPage: Codable {
    let filmDtos: [Film]
    let pageCount: Int
    let size: Int
    let status: String
}

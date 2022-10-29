//
//  User.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 29.07.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

public struct UserAuthDto: Codable {
    let email: String
    let password: String
}

public struct UserDto: Codable {
    let aboutMe: String?
    let genres: [String]?
    let id: Int
    let name: String?
    let photoId: String?
}

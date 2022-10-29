//
//  Token.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.09.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

public struct TokenDto: Codable {
    let accessToken: String
    let refreshToken: String
}

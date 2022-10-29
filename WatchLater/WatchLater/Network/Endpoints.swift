//
//  Endpoints.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.09.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

enum Endpoints: String {
    case userAuthorization = "/auth/login"
    case resetPassword = "/auth/reset"
    case updateTokens = "/auth/token"
    case registration = "/users"
    case getFilms = "/films"
    case getPoster = "/poster"
}

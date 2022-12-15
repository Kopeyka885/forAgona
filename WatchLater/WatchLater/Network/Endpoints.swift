//
//  Endpoints.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 01.09.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

enum Endpoints {
    case userAuthorization
    case resetPassword
    case updateTokens
    case registration
    case getFilms(page: Int, size: Int)
    case getPoster(id: String)
    
    case getFilmsByCategory(category: FilmCategory)
    case searchFilmByTitle(title: String)
    
    var path: String {
        switch self {
        case .userAuthorization: return "/auth/login"
        case .resetPassword: return "/auth/reset"
        case .updateTokens: return "/auth/token"
        case .registration: return "/users"
        case .getFilms: return "/films"
        case .getPoster(let id): return "/poster/\(id)"
        case .getFilmsByCategory(let category): return category.rawValue
        case .searchFilmByTitle: return FilmCategory.search.rawValue
        }
    }
    
    var method: String {
        switch self {
        case .getFilms, .getPoster, .getFilmsByCategory, .searchFilmByTitle:
            return "GET"
            
        case .registration, .userAuthorization, .resetPassword, .updateTokens:
            return "POST"
        }
    }
    
    var query: String? {
        switch self {
        case let .getFilms(page, size):
            return "page=\(page)&size=\(size)"
            
        case .searchFilmByTitle(let title):
            return title
            
        case .getPoster, .registration, .updateTokens, .resetPassword, .userAuthorization,
                .getFilmsByCategory:
            return nil
        }
    }
}

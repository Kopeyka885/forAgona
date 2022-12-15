//
//  NetworkManager.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 08.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func makeRequest(endpoint: Endpoints, auth: Bool = true) -> URLRequest {
        var urlString = baseURL + endpoint.path
        if let query = endpoint.query {
            urlString += "?" + query
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if auth, let token = KeychainService().get()?.accessToken {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func makeRequestToImdb(endpoint: Endpoints) -> URLRequest {
        var urlString = imdbBaseUrl + endpoint.path + apiKey
        if let query = endpoint.query, let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            urlString += "/\(encodedQuery)"
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func makeRequestToDownloadFile(url: String) -> URLRequest {
        let url = URL(string: url)!
        let request = URLRequest(url: url)
        return request
    }
}

private let baseURL = "https://watchlater.cloud.technokratos.com"
private let imdbBaseUrl = "https://imdb-api.com/ru/API"
private let apiKey = "k_s4yi5x2e"

//
//  NetworkManager.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 08.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

class NetworkManager {
    
    func makeRequest(path: String, method: String, query: String?) -> URLRequest {
        var urlString = baseURL + path
        if let query = query {
            urlString += "?" + query
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainService().get()?.accessToken {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

private let baseURL = "https://watchlater.cloud.technokratos.com"

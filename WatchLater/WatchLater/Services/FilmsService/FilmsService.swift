//
//  FilmsService.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 15.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol FilmsServiceProtocol {
    func downloadFilmsPage(page: Int, size: Int, completion: @escaping (Result<SystemFilmPage, Error>) -> Void)
    func downloadPoster(filmId: Int, posterId: String?, completion: @escaping (Result<Data?, Error>) -> Void)
}

class FilmsService: FilmsServiceProtocol {
    
    func downloadFilmsPage(
        page: Int,
        size: Int,
        completion: @escaping (Result<SystemFilmPage, Error>) -> Void
    ) {
        let queryParams = "page=\(page)&size=\(size)"
        let request = NetworkManager().makeRequest(path: Endpoints.getFilms.rawValue, method: "GET", query: queryParams)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validateStatusCode()
                if let data = data {
                    let decodedData = try JSONDecoder().decode(SystemFilmPage.self, from: data)
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func downloadPoster(
        filmId: Int,
        posterId: String?,
        completion: @escaping (Result<Data?, Error>) -> Void) {
            guard let id = posterId else {
                completion(.failure(NetworkError.noParameters))
                return
            }
            let path = Endpoints.getPoster.rawValue + "/\(id)"
            var request = NetworkManager().makeRequest(path: path, method: "GET", query: nil)
            request.timeoutInterval = 2
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    try response?.validateStatusCode()
                    if let data = data {
                        let decodedData = try JSONDecoder().decode(Binary.self, from: data)
                        completion(.success(decodedData.data))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}

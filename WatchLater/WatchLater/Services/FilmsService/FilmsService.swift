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
    func downloadPoster(posterId: String?, completion: @escaping (Result<Data?, Error>) -> Void)
}

class FilmsService: FilmsServiceProtocol {
    
    func downloadFilmsPage(
        page: Int,
        size: Int,
        completion: @escaping (Result<SystemFilmPage, Error>) -> Void
    ) {
        let request = NetworkManager().makeRequest(endpoint: Endpoints.getFilms(page: page, size: size))
        
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
        posterId: String?,
        completion: @escaping (Result<Data?, Error>) -> Void) {
            guard let id = posterId else {
                completion(.failure(NetworkError.noParameters))
                return
            }
            let endpoint = Endpoints.getPoster(id: id)
            let request = NetworkManager().makeRequest(endpoint: endpoint)
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

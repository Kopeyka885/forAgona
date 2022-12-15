//
//  ImdbService.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 22.10.2022.
//

import Foundation

protocol ImdbServiceProtocol {
    func getFIlms(category: FilmCategory, completion: @escaping (Result<ImdbFilmPage, Error>) -> Void)
    func downloadPoster(url: String, completion: @escaping (Result<Data, Error>) -> Void)
    func searchFilmsByTitle(title: String?, completion: @escaping (Result<ImdbSearchResult, Error>) -> Void)
}

final class ImdbService: ImdbServiceProtocol {
   
    private let networkManager = NetworkManager()
    
    func getFIlms(category: FilmCategory, completion: @escaping (Result<ImdbFilmPage, Error>) -> Void) {
        if category == .search { return }
        let request = networkManager.makeRequestToImdb(
            endpoint: .getFilmsByCategory(category: category)
        )
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validateStatusCode()
                if let data = data {
                    let decodedData = try JSONDecoder().decode(ImdbFilmPage.self, from: data)
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func downloadPoster(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = NetworkManager().makeRequestToDownloadFile(url: url)
        URLSession.shared.downloadTask(with: request) { location, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let location = location,
                  let data = try? Data(contentsOf: location) else {
                completion(.failure(NetworkError.failedToGetDataFromLocation))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    func searchFilmsByTitle(title: String?, completion: @escaping (Result<ImdbSearchResult, Error>) -> Void) {
        guard let title = title else { return }
        let request = networkManager.makeRequestToImdb(endpoint: .searchFilmByTitle(title: title))
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validateStatusCode()
                if let data = data {
                    let decodedData = try JSONDecoder().decode(ImdbSearchResult.self, from: data)
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

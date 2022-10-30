//
//  ImdbService.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 22.10.2022.
//

import Foundation

protocol ImdbServiceProtocol {
    func getRecomendationFIlms(completion: @escaping (Result<ImdbFilmPage, Error>) -> Void)
    func getTopFIlms(completion: @escaping (Result<ImdbFilmPage, Error>) -> Void)
    func downloadPoster(url: String, completion: @escaping (Result<Data, Error>) -> Void)
    func searchFilmsByTitle(searchQuery: String?, completion: @escaping (Result<ImdbSearchResult, Error>) -> Void)
}

class ImdbService: ImdbServiceProtocol {
   
    private let networkManager = NetworkManager()
    
    func getRecomendationFIlms(completion: @escaping (Result<ImdbFilmPage, Error>) -> Void) {
        let path = "/MostPopularMovies/"
        let request = networkManager.makeRequestToImdb(path: path, method: "GET", query: nil)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validateStatusCode()
                if let data = data {
                    print(data)
                    let decodedData = try JSONDecoder().decode(ImdbFilmPage.self, from: data)
                    completion(.success(decodedData))
                }
            } catch {
                print(String(describing: error))
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getTopFIlms(completion: @escaping (Result<ImdbFilmPage, Error>) -> Void) {
        let path = "/Top250Movies/"
        let request = networkManager.makeRequestToImdb(path: path, method: "GET", query: nil)
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
    
    func searchFilmsByTitle(searchQuery: String?, completion: @escaping (Result<ImdbSearchResult, Error>) -> Void) {
        let path = "/SearchMovie/"
        let request = networkManager.makeRequestToImdb(path: path, method: "GET", query: searchQuery)
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

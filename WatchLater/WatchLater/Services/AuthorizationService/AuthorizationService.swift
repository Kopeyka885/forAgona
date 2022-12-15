//
//  AuthorizationService.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 15.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol AuthorizationServiceProtocol {
    func authenticateUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthorizationService: AuthorizationServiceProtocol {
    
    func authenticateUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let user = UserAuthDto(email: email, password: password)
        guard let uploadData = try? JSONEncoder().encode(user) else {
            return
        }
        let request = NetworkManager().makeRequest(endpoint: .userAuthorization, auth: false)
        URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validateStatusCode()
                if let data = data {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(TokenDto.self, from: data)
                    _ = KeychainService(value: decodedData)
                    completion(.success(Void()))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

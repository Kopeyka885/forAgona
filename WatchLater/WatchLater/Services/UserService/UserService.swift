//
//  UserService.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 16.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    func registrateUser(email: String, password: String, completion: @escaping (Result<UserDto, Error>) -> Void)
}

class UserService: UserServiceProtocol {
    
    func registrateUser(email: String, password: String, completion: @escaping (Result<UserDto, Error>) -> Void) {
        let user = UserAuthDto(email: email, password: password)
        guard let uploadData = try? JSONEncoder().encode(user) else { return }
        let request = NetworkManager().makeRequest(endpoint: .registration, auth: false)
        URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                try response?.validateStatusCode()
                if let data = data {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(UserDto.self, from: data)
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

//
//  URLResponse+Extension.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 21.10.2022.
//

import Foundation

extension URLResponse {
    func validateStatusCode() throws {
        guard let httpResponse = self as? HTTPURLResponse else { return }
        if !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.errorStatusCode
        }
    }
}

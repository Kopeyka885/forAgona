//
//  NetworkErrors.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 15.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

enum NetworkError: String, LocalizedError {
    case errorStatusCode = "there is no 2xx response code"
    case noParameters = "there is not enough parameters"
    case errorWhileSendindRequest = "error while sending request:"
}

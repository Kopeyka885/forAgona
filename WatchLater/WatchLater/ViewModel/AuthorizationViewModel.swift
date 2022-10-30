//
//  AuthorizationViewModel.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 15.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol AuthorizationViewModelInput {
    func authorizationButtonPressed(email: String, password: String)
}

protocol AuthorizationViewModelOutput {
    var authorizationResponseReceived: (() -> Void)? { get set }
}

final class AuthorizationViewModel: AuthorizationViewModelInput, AuthorizationViewModelOutput {
    
    private let authorizationService: AuthorizationServiceProtocol
    var authorizationResponseReceived: (() -> Void)?
    
    init(authorizationService: AuthorizationServiceProtocol) {
        self.authorizationService = authorizationService
    }
    
    func authorizationButtonPressed(email: String, password: String) {
        authorizationService.authenticateUser(email: email, password: password) { result in
            switch result {
            case .success:
                self.authorizationResponseReceived?()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

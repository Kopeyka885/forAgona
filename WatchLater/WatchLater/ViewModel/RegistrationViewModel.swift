//
//  RegistrationViewModel.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 16.10.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

protocol RegistrationViewModelInput {
    func registrationButtonPressed(email: String, password: String, confirmPassword: String)
}

protocol RegistrationViewModelOutput {
    var registrationResponseReceived: (() -> Void)? { get set }
    var invalidConfirmPasswordReceived: (() -> Void)? { get set }
}

class RegistrationViewModel: RegistrationViewModelInput, RegistrationViewModelOutput {
    
    private var userService: UserServiceProtocol
    var registrationResponseReceived: (() -> Void)?
    var invalidConfirmPasswordReceived: (() -> Void)?
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func registrationButtonPressed(email: String, password: String, confirmPassword: String) {
        guard password == confirmPassword else {
            invalidConfirmPasswordReceived?()
            return
        }
        userService.registrateUser(email: email, password: password) { response in
            switch response {
            case .success:
                AuthorizationService().authenticateUser(email: email, password: password) { response in
                    self.registrationResponseReceived?()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

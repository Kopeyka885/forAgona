//
//  RegistrationViewController.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 10.08.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let appLogo = UIImageView(image: Asset.appLogoFull.image)
    
    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Asset.agonaBlue.color, for: .normal)
        button.setTitleColor(Asset.darkGray.color, for: .disabled)
        button.backgroundColor = Asset.lightGray.color
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 3
        button.layer.borderColor = Asset.lightGray.color.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.isEnabled = false
        button.setTitle(Text.Authorization.registration, for: .normal)
        return button
    }()
    
    private let emailTextField: BottomBorderedTextFieldView = {
        let textField = BottomBorderedTextFieldView()
        textField.textField.placeholder = Text.Authorization.emailAddres
        return textField
    }()
    
    private let passwordTextField: BottomBorderedTextFieldView = {
        let textField = BottomBorderedTextFieldView()
        textField.textField.placeholder = Text.Authorization.password
        textField.textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmPasswordTextField: BottomBorderedTextFieldView = {
        let textField = BottomBorderedTextFieldView()
        textField.textField.placeholder = Text.Registration.confirmPassword
        textField.textField.isSecureTextEntry = true
        return textField
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = Text.Registration.passwordsDontMatch
        return label
    }()
    
    private let loader = UIImageView(image: Asset.appLogoFull.image)
    private var viewModel: (RegistrationViewModelInput & RegistrationViewModelOutput)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel(userService: UserService())
        setupBinding()
        initializeViews()
        makeConstraints()
    }
    
    private func initializeViews() {
        view.backgroundColor = .white
        loader.isHidden = true
        
        registrationButton.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        confirmPasswordTextField.textField.delegate = self
        
        view.addSubview(confirmPasswordTextField)
        view.addSubview(loader)
        view.addSubview(appLogo)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(warningLabel)
        view.addSubview(registrationButton)
    }
    
    private func makeConstraints() {
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.26)
            make.height.equalTo(appLogo.snp.width).multipliedBy(0.43)
            make.top.equalToSuperview().offset(200)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(appLogo.snp.bottom).offset(120)
        }
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(emailTextField.snp.bottom)
        }
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
        }
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(passwordTextField.snp.width)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.height.equalTo(passwordTextField.snp.height)
        }
        registrationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(50)
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(100)
        }
        loader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(170)
        }
    }
    
    private func setupBinding() {
        viewModel.registrationResponseReceived = {
            DispatchQueue.main.async {
                self.routeToFilmsVC()
            }
        }
        viewModel.invalidConfirmPasswordReceived = {
            DispatchQueue.main.async {
                self.registrationButton.isHidden = false
                self.loader.isHidden = true
                self.warningLabel.isHidden = false
                self.passwordTextField.textField.textColor = .red
                self.confirmPasswordTextField.textField.textColor = .red
            }
        }
    }
    
    private func routeToFilmsVC() {
        let tabBarVC = MainTabBarControllerFactory.makeMainTabBar()
        present(tabBarVC, animated: false)
    }
    
    @objc private func searchTapped() {
        print("Search tapped")
    }
    
    @objc private func registrationButtonPressed() {
        guard let email = emailTextField.textField.text,
              let password = passwordTextField.textField.text,
              let confirmPassword = confirmPasswordTextField.textField.text
        else { return }
        registrationButton.isHidden = true
        loader.isHidden = false
        showLoading()
        viewModel.registrationButtonPressed(
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }
    
    private func showLoading() {
        UIView.animateKeyframes(withDuration: 2.0, delay: 0, options: .repeat) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5 / 2) {
                let angle = CGFloat.pi / 2
                self.loader.transform = CGAffineTransform(rotationAngle: angle)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5 / 2, relativeDuration: 0.5 / 2) {
                let angle = CGFloat.pi
                self.loader.transform = CGAffineTransform(rotationAngle: angle)
            }
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 2, relativeDuration: 0.5 / 2) {
                let angle = CGFloat.pi * 3 / 2
                self.loader.transform = CGAffineTransform(rotationAngle: angle)
            }
            UIView.addKeyframe(withRelativeStartTime: 1.5 / 2, relativeDuration: 0.5 / 2) {
                let angle = CGFloat.pi * 2
                self.loader.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        warningLabel.isHidden = true
        passwordTextField.textField.textColor = .black
        confirmPasswordTextField.textField.textColor = .black
        
        if emailTextField.textField.hasText &&
            passwordTextField.textField.hasText &&
            confirmPasswordTextField.textField.hasText {
            
            registrationButton.layer.borderColor = Asset.agonaBlue.color.cgColor
            registrationButton.backgroundColor = .white
            registrationButton.isEnabled = true
        } else {
            registrationButton.layer.borderColor = Asset.lightGray.color.cgColor
            registrationButton.backgroundColor = Asset.lightGray.color
            registrationButton.isEnabled = false
        }
    }
}

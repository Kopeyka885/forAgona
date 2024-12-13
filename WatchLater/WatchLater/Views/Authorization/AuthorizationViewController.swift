//
//  AuthorizationViewController.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 07.08.2022.
//  Copyright © 2022 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class AuthorizationViewController: UIViewController {
    
    private let appLogo = UIImageView(image: Asset.appLogoFull.image)
    
    private let enterButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Asset.agonaBlue.color, for: .normal)
        button.setTitleColor(Asset.darkGray.color, for: .disabled)
        button.backgroundColor = Asset.lightGray.color
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 3
        button.layer.borderColor = Asset.lightGray.color.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.isEnabled = false
        button.setTitle(Text.Authorization.enter, for: .normal)
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
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = Text.Authorization.invalidCredentials
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        return view
    }()
    
    private let registrationLabel: UILabel = {
        let label = UILabel()
        label.text = Text.Authorization.didNotRegistered
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private let registrationLink: UIButton = {
        let button = UIButton()
        button.setTitle(Text.Authorization.registration, for: .normal)
        button.setTitleColor(Asset.agonaBlue.color, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private var viewModel: (AuthorizationViewModelInput & AuthorizationViewModelOutput)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthorizationViewModel(authorizationService: AuthorizationService())
        setupBinding()
        initializeViews()
        initializeConstraints()
//        emailTextField.textField.text = "string@mail.com"
//        passwordTextField.textField.text = "string"
    }
    
    private func initializeViews() {
        view.backgroundColor = .white
        
        enterButton.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        registrationLink.addTarget(self, action: #selector(registrationLinkPressed), for: .touchUpInside)
        
        view.addSubview(appLogo)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(warningLabel)
        view.addSubview(enterButton)
        
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        
        stackView.addArrangedSubview(registrationLabel)
        stackView.addArrangedSubview(registrationLink)
        view.addSubview(stackView)
    }
    
    private func initializeConstraints() {
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.26)
            make.height.equalTo(appLogo.snp.width).multipliedBy(0.43)
            make.top.equalToSuperview().offset(200)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.equalTo(appLogo.snp.bottom).offset(150)
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
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(100)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(enterButton.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(50)
        }
    }
    
    private func setupBinding() {
        viewModel.authorizationResponseReceived = {
            DispatchQueue.main.async {
                self.routeToFilmsVC()
            }
        }
    }
    
    private func routeToFilmsVC() {
        let tabBarVC = MainTabBarControllerFactory.makeMainTabBar()
        present(tabBarVC, animated: false)
    }
    
    @objc private func enterButtonPressed() {
        guard let email = emailTextField.textField.text,
              let password = passwordTextField.textField.text
        else { return }
        viewModel?.authorizationButtonPressed(email: email, password: password)
    }
    
    @objc private func registrationLinkPressed() {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    @objc private func searchTapped() {
        print("Search tapped")
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        warningLabel.isHidden = true
        passwordTextField.textField.textColor = .black
        emailTextField.textField.textColor = .black
        if emailTextField.textField.hasText && passwordTextField.textField.hasText {
            enterButton.layer.borderColor = Asset.agonaBlue.color.cgColor
            enterButton.backgroundColor = .white
            enterButton.isEnabled = true
        } else {
            enterButton.layer.borderColor = Asset.lightGray.color.cgColor
            enterButton.backgroundColor = Asset.lightGray.color
            enterButton.isEnabled = false
        }
    }
}

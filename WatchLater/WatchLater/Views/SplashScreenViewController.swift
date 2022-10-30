//
//  SplashScreenViewController.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 27.07.2022.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    private let agonaLogo = UIImageView(image: Asset.agonaLogo.image)
    private let appLogo = UIImageView(image: Asset.appLogo.image)
    private let appLogoEye = UIImageView(image: Asset.appLogoEye.image)
    var routeToAuthVC: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        initializeConstraints()
        animateLogo()
    }
    
    private func initializeViews() {
        view.backgroundColor = .white
        
        view.addSubview(agonaLogo)
        view.addSubview(appLogo)
        view.addSubview(appLogoEye)
    }
    
    private func initializeConstraints() {
        agonaLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            agonaLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            agonaLogo.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            agonaLogo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            agonaLogo.heightAnchor.constraint(equalTo: agonaLogo.widthAnchor, multiplier: 0.5)])
        
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appLogo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            appLogo.heightAnchor.constraint(equalTo: appLogo.widthAnchor, multiplier: 0.43)])
        
        appLogoEye.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appLogoEye.centerXAnchor.constraint(equalTo: appLogo.centerXAnchor, constant: -7),
            appLogoEye.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appLogoEye.widthAnchor.constraint(equalTo: appLogo.heightAnchor, multiplier: 0.4),
            appLogoEye.heightAnchor.constraint(equalTo: appLogoEye.widthAnchor)])
    }
    
    private func animateLogo() {
        let offset = 12.0
        
        UIView.animate(withDuration: 0.5, delay: 1, animations: { [self] in
            self.appLogoEye.center.x = appLogoEye.center.x - offset }, completion: { [self] _ in
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: { [self] in
                    self.appLogoEye.center.x = appLogoEye.center.x + 2 * offset}, completion: { [self] _ in
                        UIView.animate(withDuration: 0.5, delay: 0.5, animations: { [self] in
                            self.appLogoEye.center.x = appLogoEye.center.x - offset}, completion: { _ in self.routeToAuthVC?() })
                    })
            })
    }
}

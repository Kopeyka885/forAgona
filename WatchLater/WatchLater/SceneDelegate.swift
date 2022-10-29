//
//  SceneDelegate.swift
//  StartProject-ios
//
//  Created by Kamil Kadyrov on 27.07.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        
        let splashScreen = SplashScreenViewController()
        window.rootViewController = splashScreen
        
        splashScreen.routeToAuthVC = {
            let authVC = AuthorizationViewController()
            window.rootViewController = UINavigationController(rootViewController: authVC)
        }
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

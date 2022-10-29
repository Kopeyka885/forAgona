//
//  MainTabBarControllerFactory.swift
//  StartProject-ios
//
//  Created by Камиль Кадыров on 21.10.2022.
//

import Foundation
import UIKit

enum MainTabBarControllerFactory {
    static func makeMainTabBar() -> UITabBarController {
        let filmsVC = UINavigationController(rootViewController: FilmsViewController())
        filmsVC.title = Text.Films.collection
        let addFilmsVC = UINavigationController(rootViewController: AddFilmsViewController())
        addFilmsVC.title = Text.Films.add
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.title = Text.Common.profile
        
        let tabbarVC = UITabBarController()
        tabbarVC.setViewControllers([filmsVC, addFilmsVC, profileVC], animated: false)
        tabbarVC.tabBar.tintColor = Asset.agonaBlue.color
        tabbarVC.tabBar.items?[0].image = Asset.collection.image
        tabbarVC.tabBar.items?[1].image = Asset.add.image
        tabbarVC.tabBar.items?[2].image = Asset.profile.image
        tabbarVC.modalPresentationStyle = .fullScreen
        tabbarVC.tabBar.backgroundColor = Asset.lightGray.color
        return tabbarVC
    }
}

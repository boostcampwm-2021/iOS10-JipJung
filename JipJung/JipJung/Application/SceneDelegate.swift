//
//  SceneDelegate.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        self.configure(tabBarController.tabBar)
        
        tabBarController.viewControllers = [
            createHomeViewController(),
            createExploreNavigationViewController(),
            createMeViewController()
        ]
        return tabBarController
    }
    
    private func configure(_ tabBar: UITabBar) {
        tabBar.backgroundImage = UIImage()
        tabBar.barTintColor = .clear
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        tabBar.makeBlurBackground()
    }
    
    private func createHomeViewController() -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: TabBarItems.Home.title,
            image: UIImage(systemName: TabBarItems.Home.image),
            tag: 0
        )
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = tabBarItem
        return homeViewController
    }
    
    private func createExploreNavigationViewController() -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: TabBarItems.Explore.title,
            image: UIImage(systemName: TabBarItems.Explore.image),
            tag: 1
        )
        
        let exploreViewController = ExploreViewController()
        let exploreNavigationViewController = UINavigationController(rootViewController: exploreViewController)
        exploreNavigationViewController.tabBarItem = tabBarItem
        return exploreNavigationViewController
    }
    
    private func createMeViewController() -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: TabBarItems.Me.title,
            image: UIImage(systemName: TabBarItems.Me.image),
            tag: 2
        )
        
        let meViewController = MeViewController()
        let meNavigationController = UINavigationController(rootViewController: meViewController)
        meNavigationController.tabBarItem = tabBarItem
        meNavigationController.navigationBar.prefersLargeTitles = true
        return meNavigationController
    }
}

//
//  SceneDelegate.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/01.
//

import UIKit

import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let localFileManager: LocalFileAccessible = LocalFileManager()
    private let localDBManager: LocalDBManageable = RealmDBManager()
    private let userDefaultsManager: UserDefaultsStorable = UserDefaultsStorage()
    private let remoteServiceProvider: RemoteServiceAccessible = RemoteServiceProvider()

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
        
        let audioPlayUseCase = AudioPlayUseCase(
            mediaResourceRepository: MediaResourceRepository(
                localFileManager: localFileManager,
                remoteServiceProvider: remoteServiceProvider
            )
        )
        
        tabBarController.viewControllers = [
            createHomeViewController(audioPlayUseCase),
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
    
    // TODO: Protocol로 의존성 제거 필요
    private func createHomeViewController(_ audioPlayUseCase: AudioPlayUseCase) -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: TabBarItems.Home.title,
            image: UIImage(systemName: TabBarItems.Home.image),
            tag: 0
        )
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = tabBarItem
        homeViewController.localFileManager = localFileManager
        homeViewController.localDBManager = localDBManager
        homeViewController.userDefaultsManager = userDefaultsManager
        homeViewController.remoteServiceProvider = remoteServiceProvider
        homeViewController.audioPlayUseCase = audioPlayUseCase
        return homeViewController
    }
    
    func createExploreNavigationViewController() -> UIViewController {
        let tabBarItem = UITabBarItem(
            title: TabBarItems.Explore.title,
            image: UIImage(systemName: TabBarItems.Explore.image),
            tag: 1
        )
        
        let exploreViewController = ExploreViewController()
        exploreViewController.tabBarItem = tabBarItem
        let exploreNavigationViewController = UINavigationController(rootViewController: exploreViewController)
        
        return exploreNavigationViewController
    }
    
    func createMeViewController() -> UIViewController {
        let meViewController = MeViewController()
        meViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        return meViewController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

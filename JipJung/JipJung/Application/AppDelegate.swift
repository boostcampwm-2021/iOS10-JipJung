//
//  AppDelegate.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/01.
//

import UIKit

import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let applicationLaunch = ApplicationLaunch()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        applicationLaunch.start()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

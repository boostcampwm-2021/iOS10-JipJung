//
//  ApplicationLaunch.swift
//  JipJung
//
//  Created by turu on 2021/11/13.
//

import AVKit
import Foundation

import Firebase
import RealmSwift

final class ApplicationLaunch: NSObject {
    func start() {
        configureFirebase()
        configureAudioSession()
        configureLocalNotification()
        
        if isFirstLaunch() {
            do {
                try configureInnerDB()
            } catch {
                print(error)
                return
            }
            let key = UserDefaultsKeys.wasLaunchedBefore
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    #if DEBUG
    func makeDebugLaunch() throws {
        try? FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL ?? URL(fileURLWithPath: ""))
        let key = UserDefaultsKeys.wasLaunchedBefore
        UserDefaults.standard.set(false, forKey: key)
        do {
            guard let url = BundleManager.shared
                    .findURL(fileNameWithExtension: "DummyFocusData.json")
            else {
                throw ApplicationLaunchError.resourceJsonFileNotFound
            }
            
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let jsonValue = try jsonDecoder.decode([FocusRecord].self, from: data)
            
            try LocalDBMigrator.shared.migrate(dataList: jsonValue)
        } catch {
            print(error)
        }
    }
    #endif
    
    private func isFirstLaunch() -> Bool {
        let key = UserDefaultsKeys.wasLaunchedBefore
        let wasLaunchedBefore = UserDefaults.standard.bool(forKey: key)
        let isFirstLaunch = !wasLaunchedBefore
        return isFirstLaunch
    }
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    private func configureInnerDB() throws {
        do {
            guard let url = BundleManager.shared
                    .findURL(fileNameWithExtension: "DummyData.json")
            else {
                throw ApplicationLaunchError.resourceJsonFileNotFound
            }
            
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            let jsonValue = try jsonDecoder.decode(DBStructureForJSON.self, from: data)
            
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.allMediaList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.favoriteMediaList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.brightModeList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.darknessModeList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.playHistoryList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.maximList)
        } catch {
            throw error
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                mode: AVAudioSession.Mode.default,
                options: [.defaultToSpeaker, .allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func configureLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert,
                                                          .sound]) {
            (didAllow, error) in
            print(#function, #line, didAllow, error)
        }
        UNUserNotificationCenter.current().delegate = self
    }
}

extension ApplicationLaunch: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler(.banner)
        } else {
            completionHandler(.alert)
        }
    }
}

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

final class ApplicationLaunch {
    func start() {
        configureFirebase()
        configureAudioSession()
        
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
            let jsonValue = try JSONDecoder().decode(DBStructureForJSON.self, from: data)
            
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.allMediaList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.favoriteMediaList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.brightModeList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.darknessModeList)
            try LocalDBMigrator.shared.migrate(dataList: jsonValue.playHistoryList)
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
}

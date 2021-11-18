//
//  UserDefaultsStorage.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import Foundation

final class UserDefaultsStorage {
    static let shared = UserDefaultsStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    func save(for key: String, value: Int) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func save(for key: String, value: [String]) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func load(for key: String) -> Int? {
        let value = userDefaults.integer(forKey: key)
        return value == 0 ? nil : value
    }
    
    func load(for key: String) -> [String]? {
        guard let value = userDefaults.object(forKey: key) as? [String] else { return nil }
        return value
    }
}

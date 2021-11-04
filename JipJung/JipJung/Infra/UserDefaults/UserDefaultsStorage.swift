//
//  UserDefaultsStorage.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/04.
//

import Foundation

protocol UserDefaultsStorable {
    func save(for key: String, integer: Int)
    func save(for key: String, stringArray: [String])
    func load(for key: String) -> Int
    func load(for key: String) -> [String]?
}

final class UserDefaultsStorage: UserDefaultsStorable {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func save(for key: String, integer: Int) {
        userDefaults.set(integer, forKey: key)
    }
    
    func save(for key: String, stringArray: [String]) {
        userDefaults.set(stringArray, forKey: key)
    }
    
    func load(for key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    func load(for key: String) -> [String]? {
        guard let stringArray = userDefaults.object(forKey: key) as? [String] else { return nil }
        return stringArray
    }
}

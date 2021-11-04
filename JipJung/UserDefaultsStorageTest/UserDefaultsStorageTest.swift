//
//  UserDefaultsStorageTest.swift
//  UserDefaultsStorageTest
//
//  Created by 오현식 on 2021/11/04.
//

import XCTest
@testable import JipJung

class UserDefaultsStorageTest: XCTestCase {
    
    var userDefaultsStorage: UserDefaultsStorage!

    override func setUpWithError() throws {
        userDefaultsStorage = UserDefaultsStorage()
    }

    override func tearDownWithError() throws {
        userDefaultsStorage = nil
    }
    
    func testuserDefaultsStorage_saveIntValue() {
        userDefaultsStorage.save(for: "test", value: 6)
        
        let value = UserDefaults.standard.integer(forKey: "test")
        
        XCTAssertEqual(value, 6)
    }

    func testuserDefaultsStorage_loadIntValue() {
        UserDefaults.standard.set(6, forKey: "test")
        
        let value: Int? = userDefaultsStorage.load(for: "test")
        
        XCTAssertNotNil(value)
        XCTAssertEqual(6, value)
    }
    
    func testuserDefaultsStorage_saveStringArrayValue() {
        userDefaultsStorage.save(for: "test", value: ["test1", "test2", "test3"])
        
        let value = UserDefaults.standard.object(forKey: "test")
        
        XCTAssertNotNil(value)
        guard let value = value as? [String] else { return }
        
        XCTAssertEqual(value, ["test1", "test2", "test3"])
    }

    func testuserDefaultsStorage_loadStringArrayValue() {
        UserDefaults.standard.set(["test1", "test2", "test3"], forKey: "test")
        
        let value: [String]? = userDefaultsStorage.load(for: "test")
        
        XCTAssertNotNil(value)
        XCTAssertEqual(["test1", "test2", "test3"], value)
    }
}

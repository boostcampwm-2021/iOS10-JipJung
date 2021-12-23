//
//  FocusTimeRealmTests.swift
//  RealmTests
//
//  Created by 윤상진 on 2021/12/23.
//

import XCTest
@testable import JipJung

import RealmSwift
import RxBlocking

class FocusTimeRealmTests: XCTestCase {
    
    var loadFocusTimeUseCase: LoadFocusTimeUseCase! = nil
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
        try! ApplicationLaunch().makeDebugLaunch()
        loadFocusTimeUseCase = LoadFocusTimeUseCase(focusTimeRepository: FocusTimeRepository())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            for i in 1...100 {
                let historyObservable = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: 140).asObservable().toBlocking()
                let data = try! historyObservable.first()!
                print(data)
            }
        }
    }

}

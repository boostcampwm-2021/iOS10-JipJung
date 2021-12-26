//
//  FocusTimeRealmTests.swift
//  RealmTests
//
//  Created by 윤상진 on 2021/12/23.
//

import XCTest
@testable import JipJung

import Nimble
import RealmSwift
import RxBlocking
import RxSwift

class FocusTimeRealmTests: XCTestCase {
    var loadFocusTimeUseCase: LoadFocusTimeUseCase! = nil
        
    override func setUpWithError() throws {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
        try! ApplicationLaunch().makeDebugLaunch()
        loadFocusTimeUseCase = LoadFocusTimeUseCase(focusTimeRepository: FocusTimeRepository())
    }

    func test_realm을_사용하는_loadHistory의_성능측정() throws {
        self.measure {
            let historyObservable = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: 140).asObservable().toBlocking()
            _ = try! historyObservable.first()!
        }
    }
}

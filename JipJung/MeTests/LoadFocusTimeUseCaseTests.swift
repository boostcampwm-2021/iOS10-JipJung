//
//  LoadFocusTimeUseCaseTests.swift
//  MeTests
//
//  Created by 윤상진 on 2022/01/02.
//

import XCTest

import Nimble
import RxBlocking

class LoadFocusTimeUseCaseTests: XCTestCase {
    var loadFocusTimeUseCase: LoadFocusTimeUseCase! = nil
    let date = Date()
    let nDays = 140
    let oneDay = TimeInterval(86400)
    var dates: [Date] { (0..<nDays).map {
        date.addingTimeInterval(-oneDay * Double($0))
        }
    }
    var focusTimes: [Date: DateFocusRecord] {
        [Date: DateFocusRecord](
            uniqueKeysWithValues:
                dates.map {
                    ($0.midnight,
                     DateFocusRecord(id: $0.midnight))
                }
        )
    }
        
    override func setUpWithError() throws {
        let loadFocusTimeRepositoryStub =
        LoadFocusTimeRepositoryStub(focusTimes: focusTimes)
        loadFocusTimeUseCase = LoadFocusTimeUseCase(focusTimeRepository: loadFocusTimeRepositoryStub)
    }
    
    func test_LoadHistory_성공() throws {
        do {
            _ = try loadFocusTimeUseCase.loadHistory(from: date, nDays: nDays)
                .toBlocking()
                .single()
        } catch {
            expect(error).to(raiseException())
        }
    }
    
    func test_LoadHistory는_요청한_nDays개의_결과반환() throws {
        let loadHistoryResults = try! loadFocusTimeUseCase.loadHistory(from: date, nDays: nDays)
            .toBlocking()
            .single()
        expect(loadHistoryResults.count) == nDays
    }
    
    func test_LoadHistory는_요청한_Day부터_nDays이전부터_Day까지의_결과반환() throws {
        let loadHistoryResults = try! loadFocusTimeUseCase.loadHistory(from: date, nDays: nDays)
            .toBlocking()
            .single()
        
        zip(dates.reversed(), loadHistoryResults).forEach { date, loadHistoryResult in
            expect(date.midnight) == loadHistoryResult.date.midnight
        }
    }
}

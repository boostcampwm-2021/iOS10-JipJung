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
    func test_LoadHistory_성공() throws {
        let oneDay = TimeInterval(86400)
        let date = Date()
        let nDays = 140
        let dates = (0..<nDays).map {
            date.addingTimeInterval(-oneDay * Double($0))
        }
        var focusTimes = [Date: DateFocusRecord]()
        dates.forEach {
            focusTimes[$0.midnight] = DateFocusRecord(id: $0)
        }
        let loadFocusTimeRepositoryStub =
        LoadFocusTimeRepositoryStub(focusTimes: focusTimes)
        let loadFocusTimeUseCase = LoadFocusTimeUseCase(focusTimeRepository: loadFocusTimeRepositoryStub)
        do {
            _ = try loadFocusTimeUseCase.loadHistory(from: date, nDays: nDays)
                .toBlocking()
                .single()
        } catch {
            expect(error).to(raiseException())
        }
    }
    
    func test_LoadHistory는_요청한_nDays개의_결과반환() throws {
        let oneDay = TimeInterval(86400)
        let date = Date()
        let nDays = 140
        let dates = (0..<nDays).map {
            date.addingTimeInterval(-oneDay * Double($0))
        }
        var focusTimes = [Date: DateFocusRecord]()
        dates.forEach {
            focusTimes[$0.midnight] = DateFocusRecord(id: $0)
        }
        let loadFocusTimeRepositoryStub =
        LoadFocusTimeRepositoryStub(focusTimes: focusTimes)
        let loadFocusTimeUseCase = LoadFocusTimeUseCase(focusTimeRepository: loadFocusTimeRepositoryStub)
        
        let loadHistoryResults = try! loadFocusTimeUseCase.loadHistory(from: date, nDays: nDays)
            .toBlocking()
            .single()
        expect(loadHistoryResults.count) == nDays
    }
    
    func test_LoadHistory는_요청한_Day부터_nDays이전부터_Day까지의_결과반환() throws {
        let oneDay = TimeInterval(86400)
        let date = Date()
        let nDays = 140
        let dates = (0..<nDays).map {
            date.addingTimeInterval(-oneDay * Double($0))
        }
        var focusTimes = [Date: DateFocusRecord]()
        dates.forEach {
            focusTimes[$0.midnight] = DateFocusRecord(id: $0)
        }
        let loadFocusTimeRepositoryStub =
        LoadFocusTimeRepositoryStub(focusTimes: focusTimes)
        let loadFocusTimeUseCase = LoadFocusTimeUseCase(focusTimeRepository: loadFocusTimeRepositoryStub)
        
        let loadHistoryResults = try! loadFocusTimeUseCase.loadHistory(from: date, nDays: nDays)
            .toBlocking()
            .single()
        
        zip(dates.reversed(), loadHistoryResults).forEach { date, loadHistoryResult in
            expect(date.midnight) == loadHistoryResult.date.midnight
        }
    }
}

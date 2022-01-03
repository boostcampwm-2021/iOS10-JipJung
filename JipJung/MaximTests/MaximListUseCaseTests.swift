//
//  MaximTests.swift
//  MaximTests
//
//  Created by 윤상진 on 2021/11/30.
//

import XCTest

import Nimble
import RxSwift
import RxBlocking
import RealmSwift

class MaximListUseCaseTests: XCTestCase {
    func test_Fetch의결과는_항상7의배수() throws {
        var testMaximData = [Maxim]()
        for i in 1...7 {
            let maximUseCase = MaximListUseCase(maximListRepository: MaximListRepositoryStub(testData: testMaximData))
            let fetchObservable = maximUseCase.fetchWeeksMaximList()
                .asObservable()
                .toBlocking()
            let maximList = try! fetchObservable.first()!
            expect(maximList.count % 7).to(equal(0))
            testMaximData.append(Maxim(id: "\(i)", date: Date(), thumbnailImageFileName: "", content: "", speaker: ""))
        }
    }
    
    func test_Fetch결과는_시간역순배열() {
        let forwardTestMaximData: [Maxim] = (1...10).map({
            let date = dateGenerator(baseDate: Date(), dateInterval: $0)
            return testMaximGenerator(date: date)
        })
        let maximUseCase = MaximListUseCase(maximListRepository: MaximListRepositoryStub(testData: forwardTestMaximData))
        let maximObservable = maximUseCase.fetchWeeksMaximList().asObservable()

        let maximData = try! maximObservable.toBlocking().single()
        if maximData.count == 0 {
            return
        }
        for cur in 1..<maximData.count {
            let prev = cur - 1
            let prevDate = maximData[prev].date
            let curDate = maximData[cur].date
            expect(prevDate).to(beGreaterThan(curDate))
        }
    }
    
    func test_Fetch결과는_시간역순배열_실패() {
        let forwardTestMaximData: [Maxim] = (1...10).map({
            let date = dateGenerator(baseDate: Date(), dateInterval: $0)
            return testMaximGenerator(date: date)
        })
        let maximUseCase = MaximListUseCase(maximListRepository: MaximListRepositoryStub(testData: forwardTestMaximData))
        let maximObservable = maximUseCase.fetchWeeksMaximList().asObservable()

        let maximData = try! maximObservable.toBlocking().single()
        if maximData.count == 0 {
            return
        }
        for cur in 1..<maximData.count {
            let prev = cur - 1
            let prevDate = maximData[prev].date
            let curDate = maximData[cur].date
            expect(prevDate).notTo(beLessThan(curDate))
        }
    }
    
    private func testMaximGenerator(date: Date) -> Maxim {
        return Maxim(id: "", date: date, thumbnailImageFileName: "", content: "", speaker: "")
    }
    
    private func dateGenerator(baseDate: Date, dateInterval: Int) -> Date {
        return baseDate.addingTimeInterval(Double(dateInterval) * TimeInterval(86400))
    }
}

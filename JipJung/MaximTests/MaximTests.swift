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

class MaximTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        expect(123).to(equal(123))
        let observable = Observable.from([1, 2, 3]).toBlocking()
        expect(try? observable.toArray()).to(equal([1, 2, 2]))
        XCTAssertEqual(3, 3, "3 is Equal 3")
    }
    
    func testMaximListUseCaseCanFetchListCountThatIsMultiple7() throws {
        let maximUseCase = MaximListUseCase(maximListRepository: MaximListRepositoryStub(testData: []))
        let fetchObservable = maximUseCase.fetchWeeksMaximList()
            .asObservable()
            .toBlocking()
        let maximList = try! fetchObservable.first()!
        expect(maximList.count % 7).to(equal(0))
    }
    
    func testMaximListUseCaseCanFetchFirstItemHasTodyDate() {
    }
}

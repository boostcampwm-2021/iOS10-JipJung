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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
//        try! ApplicationLaunch().makeDebugLaunch()
        loadDataToRealmTest2()
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
            for i in 1...1 {
                let historyObservable = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: 140).asObservable().toBlocking()
                let data = try! historyObservable.first()!
            }
        }
    }
    
    func testPerformanceByV2() throws {
        self.measure {
            for i in 1...1 {
                let historyObservable = self.loadHistory(from: Date(), nDays: 140).asObservable().toBlocking()
                let data = try! historyObservable.first()!
            }
        }
    }
    
    func test_Realm한_저장방식이_기존의_방식과_같은데이터가_맞는지() throws {
        let historyObservable1 = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: 140).asObservable().toBlocking()
        let data1 = try! historyObservable1.first()!
        
        let historyObservable2 = self.loadHistory(from: Date(), nDays: 140).asObservable().toBlocking()
        let data2 = try! historyObservable2.first()!
        expect(data1).to(equal(data2))
        
    }
    
    private func loadDataToRealmTest2() {
        try? FileManager.default.removeItem(
            at: Realm.Configuration.defaultConfiguration.fileURL ?? URL(fileURLWithPath: "")
        )
        let key = UserDefaultsKeys.wasLaunchedBefore
        UserDefaults.standard.set(false, forKey: key)
        do {
            guard let url = BundleManager.shared
                    .findURL(fileNameWithExtension: "DummyFocusData.json")
            else {
                throw ApplicationLaunchError.resourceJsonFileNotFound
            }
            
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let jsonValue = try jsonDecoder.decode([FocusRecord].self, from: data)
            for focusRecord in jsonValue {
                addTime(focusRecordTime: focusRecord)
            }
            try LocalDBMigrator.shared.migrate(dataList: jsonValue)
        } catch {
            print(error)
        }
        guard let realm = try? Realm() else {
            return
        }
    }
    
    private func addTime(focusRecordTime: FocusRecord) {
        guard let realm = try? Realm() else {
            return
        }
        
        do {
            try realm.write({
                let dateKey = "\(focusRecordTime.year)\(focusRecordTime.month)\(focusRecordTime.day)"
                if let focusRecord = realm.object(ofType: FocusRecordV2.self, forPrimaryKey: dateKey) {
                    focusRecord.focusTime.append(focusRecordTime)
                } else {
                    let focusRecord = FocusRecordV2(id: dateKey)
                    focusRecord.focusTime.append(focusRecordTime)
                    realm.add(focusRecord)
                }
            })
        } catch {
            return
        }
    }
    
    private func loadHistory(from date: Date, nDays: Int) -> Observable<[DateFocusRecordDTO]> {
        let oneDay = TimeInterval(86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dateObservable = Observable.from(Array(0..<nDays))
            .map {
                date.addingTimeInterval(-oneDay * Double($0))
            }
        let focusRecordObservable = dateObservable
            .flatMap {
                self.read(date: $0)
            }
        return Observable.zip(dateObservable, focusRecordObservable)
            .map { date, focusRecords -> DateFocusRecordDTO in
                let focusSecond = focusRecords.focusTime.reduce(0) { $0 + $1.focusTime }
                return DateFocusRecordDTO(date: date, focusSecond: focusSecond)
            }
            .toArray()
            .map({$0.sorted(by: <)})
            .asObservable()
    }
    
    private func read(date: Date) -> Single<FocusRecordV2> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                if let data = try! Realm().object(ofType: FocusRecordV2.self, forPrimaryKey: date.realmId) {
                    single(.success(data))
                } else {
                    single(.success(FocusRecordV2(id: date)))
                }
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
    
}

//class FakeRealmDBManager {
//
//}

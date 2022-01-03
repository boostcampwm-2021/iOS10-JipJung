//
//  FocusTimeRepositoryStub.swift
//  MeTests
//
//  Created by 윤상진 on 2022/01/02.
//

import Foundation

import RxSwift

struct LoadFocusTimeRepositoryStub: FocusTimeRepositoryProtocol {
    var focusTimes = [Date: DateFocusRecord]()
    
    func create(record: FocusRecord) -> Single<Bool> {
        return Single.create { _ in return Disposables.create()}
    }
    
    func read(date: Date) -> Single<DateFocusRecord> {
        return Single.create { single in
            if let dateFocusRecord = focusTimes[date] {
                single(.success(dateFocusRecord))
            } else {
                single(.success(DateFocusRecord(id: date)))
            }
            return Disposables.create()
        }
    }
}

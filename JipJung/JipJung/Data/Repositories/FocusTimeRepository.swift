//
//  FocusTimeRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

import RxSwift

final class FocusTimeRepository: FocusTimeRepositoryProtocol {
    private let localDBManager = RealmDBManager.shared
    
    func create(record: FocusRecord) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let dateKey = "\(record.year)\(record.month)\(record.day)"
                let dateFocusRecord: DateFocusRecord
                if let dateFocusRecordObject = try self.localDBManager.object(ofType: DateFocusRecord.self, forPrimaryKey: dateKey) {
                    dateFocusRecord = dateFocusRecordObject
                    try dateFocusRecord.realm?.write({
                        dateFocusRecord.focusTime.append(record)
                    })
                } else {
                    dateFocusRecord = DateFocusRecord(id: dateKey)
                    dateFocusRecord.focusTime.append(record)
                }
                try self.localDBManager.add(dateFocusRecord)
            } catch {
                single(.failure(error))
            }
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func read(date: Date) -> Single<DateFocusRecord> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                if let result = try self.localDBManager.object(
                    ofType: DateFocusRecord.self,
                    forPrimaryKey: date.realmId
                ) {
                    single(.success(result))
                } else {
                    single(.success(DateFocusRecord(id: date)))
                }
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
}

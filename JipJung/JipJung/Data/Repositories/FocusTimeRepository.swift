//
//  FocusTimeRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

import RxSwift

protocol FocusTimeRepositoryProtocol {
    func create(record: FocusRecord) -> Single<Bool>
    func read(date: Date) -> Single<[FocusRecord]>
}

final class FocusTimeRepository: FocusTimeRepositoryProtocol {
    private let localDBManager = RealmDBManager.shared
    
    func create(record: FocusRecord) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                try self.localDBManager.add(record)
            } catch {
                single(.failure(error))
            }
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func read(date: Date) -> Single<[FocusRecord]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let predicate = NSPredicate(
                    format: "(year = %@) AND (month = %@) AND (day = %@)",
                    argumentArray: [
                        date.year,
                        date.month,
                        date.day
                    ]
                )
                let result = try self.localDBManager.objects(
                    ofType: FocusRecord.self,
                    with: predicate
                )
                single(.success(result))
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
}

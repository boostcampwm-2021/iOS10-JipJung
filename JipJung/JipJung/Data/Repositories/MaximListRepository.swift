//
//  MaximListRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

final class MaximListRepository {
    private let localDBManager = RealmDBManager.shared
    
    func read(from date: Date) -> Single<[Maxim]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let predicate = NSPredicate(format: "date < %@", date as CVarArg)
                let result = try self.localDBManager.objects(
                    ofType: Maxim.self,
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

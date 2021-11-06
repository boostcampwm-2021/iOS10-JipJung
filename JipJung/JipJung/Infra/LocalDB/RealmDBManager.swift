//
//  RealmDBManager.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation
import RxSwift
import RealmSwift

protocol LocalDBManageable {
    func search<T: Object>(with predicate: NSPredicate?) -> Single<[T]>
    func write(_ value: Object) -> Single<Bool>
    func delete(_ value: Object) -> Single<Bool>
}

class RealmDBManager: LocalDBManageable {
    enum RealmError: Error {
        case initFail, searchFail
    }

    let shared = RealmDBManager()
    
    private init() {}
    
    func search<T: Object>(with predicate: NSPredicate? = nil) -> Single<[T]> {
        let realm = try? Realm()
        return Single.create { observal in
            guard let realm = realm else {
                observal(.failure(RealmError.initFail))
                return Disposables.create()
            }
            if let predicate = predicate {
                let realmObjects = realm.objects(T.self).filter(predicate)
                let elements = try? realmObjects.compactMap({ element throws in element})
                if let elements = elements {
                    observal(.success(elements))
                    return Disposables.create()
                }
            } else {
                let realmObjects = realm.objects(T.self)
                let elements = try? realmObjects.compactMap({ element throws in element})
                if let elements = elements {
                    observal(.success(elements))
                    return Disposables.create()
                }
            }
            observal(.failure(RealmError.searchFail))

            return Disposables.create()
        }
    }
    
    func write(_ value: Object) -> Single<Bool> {
        let realm = try? Realm()
        return Single.create { observal in
            do {
                try realm?.write({
                    realm?.add(value, update: .all)
                    observal(.success(true))
                })
            } catch {
                observal(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func delete(_ value: Object) -> Single<Bool> {
        let realm = try? Realm()
        return Single.create { observal in
            realm?.delete(value)
            observal(.success(true))
            return Disposables.create()
        }
    }
}

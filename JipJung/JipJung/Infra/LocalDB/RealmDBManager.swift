//
//  RealmDBManager.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift
import RxSwift

class RealmDBManager {
    static let shared = RealmDBManager()
    private init() {}
    
    func search<T: Object>(ofType: T.Type, with predicate: NSPredicate? = nil) -> Single<[T]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            if let predicate = predicate {
                let realmObjects = realm.objects(T.self).filter(predicate)
                let elements = try? realmObjects.compactMap({ element throws in element})
                if let elements = elements {
                    single(.success(elements))
                    return Disposables.create()
                }
            } else {
                let realmObjects = realm.objects(T.self)
                let elements = try? realmObjects.compactMap({ element throws in element})
                if let elements = elements {
                    single(.success(elements))
                    return Disposables.create()
                }
            }
            single(.failure(RealmError.searchFailed))

            return Disposables.create()
        }
    }
    
    func searchTest<T: Object>(ofType: T.Type, with predicate: NSPredicate? = nil) throws -> [T] {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        if let predicate = predicate {
            return Array(realm.objects(T.self).filter(predicate))
        } else {
            return Array(realm.objects(T.self))
        }
    }
    
    func write(_ value: Object) -> Single<Bool> {
        let realm = try? Realm()
        return Single.create { single in
            do {
                try realm?.write({
                    realm?.add(value, update: .all)
                    single(.success(true))
                })
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func add(_ value: Object) throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        do {
            try realm.write({
                realm.add(value, update: .all)
            })
        } catch {
            throw RealmError.addFailed
        }
    }
    
    func writeData(_ value: Object) throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        do {
            try realm.write({
                realm.add(value, update: .all)
            })
        } catch {
            throw RealmError.addFailed
        }
    }
    
    func delete(_ value: Object) -> Single<Bool> {
        let realm = try? Realm()
        return Single.create { single in
            do {
                try realm?.write({
                    realm?.delete(value)
                    single(.success(true))
                })
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteTest(_ value: Object) throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        do {
            try realm.write({
                realm.delete(value)
            })
        } catch {
            throw RealmError.deleteFailed
        }
    }
    
    func requestFavoriteMediaList() -> Single<[Media]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            let favoriteMediaList = realm.objects(FavoriteMedia.self)
            let favoriteMediaIDs = try? favoriteMediaList.compactMap({ element throws in element.id})
            
            guard let ids = favoriteMediaIDs else {
                single(.failure(RealmError.searchFailed))
                return Disposables.create()
            }
            
            let filteredMedia = realm.objects(Media.self).filter("id IN %@", ids)
            let result = try? filteredMedia.compactMap({ element throws in element})
            if let result = result {
                single(.success(result))
            } else {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
}

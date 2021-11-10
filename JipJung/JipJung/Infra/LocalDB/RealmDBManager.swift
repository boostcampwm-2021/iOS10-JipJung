//
//  RealmDBManager.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift
import RxSwift

class RealmDBManager: LocalDBManageable {
    let shared = RealmDBManager()
    private init() {}
    
    func search<T: Object>(with predicate: NSPredicate? = nil) -> Single<[T]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initError))
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
            single(.failure(RealmError.searchError))

            return Disposables.create()
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
    
    func delete(_ value: Object) -> Single<Bool> {
        let realm = try? Realm()
        return Single.create { single in
            realm?.delete(value)
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func requestFavoriteMedia() -> Single<[Media]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initError))
                return Disposables.create()
            }
            
            let favoriteMediaList = realm.objects(FavoriteMedia.self)
            let favoriteMediaIDs = try? favoriteMediaList.compactMap({ element throws in element.id})
            
            guard let ids = favoriteMediaIDs else {
                single(.failure(RealmError.searchError))
                return Disposables.create()
            }
            
            let filteredMedia = realm.objects(Media.self).filter("id IN %@", ids)
            let filteredMediaList = try? filteredMedia.compactMap({ element throws in element})
            
            if let filteredMediaList = filteredMediaList {
                single(.success(filteredMediaList))
            } else {
                single(.failure(RealmError.searchError))
            }
            return Disposables.create()
        }
    }
    
    func requestFavoriteMaxim() -> Single<[Maxim]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initError))
                return Disposables.create()
            }
            
            let favoriteMaximList = realm.objects(FavoriteMaxim.self)
            let favoriteMaximIDs = try? favoriteMaximList.compactMap({ element throws in element.id})
            
            guard let ids = favoriteMaximIDs else {
                single(.failure(RealmError.searchError))
                return Disposables.create()
            }
            
            let filteredMaxin = realm.objects(Maxim.self).filter("id IN %@", ids)
            let filteredMaximList = try? filteredMaxin.compactMap({ element throws in element})
            
            if let filteredMaximList = filteredMaximList {
                single(.success(filteredMaximList))
            } else {
                single(.failure(RealmError.searchError))
            }
            return Disposables.create()
        }
    }
}

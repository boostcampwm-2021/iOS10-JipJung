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
    
    func search<T: Object>(with predicate: NSPredicate? = nil) -> Single<[T]> {
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
    
    func writeData(_ value: Object) throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        do {
            try realm.write({
                realm.add(value, update: .all)
            })
        } catch {
            throw RealmError.writeFailed
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

    // TODO: NSPredicte를 활용한 Search 함수를 적극적으로 이용하기 - 기존 request 함수 대체
    
    func requestAllMediaList() -> Single<[Media]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            let mediaList = realm.objects(Media.self)
            let result = try? mediaList.compactMap({ element throws in element })
            if let result = result {
                single(.success(result))
            } else {
                single(.failure(RealmError.searchFailed))
            }
            
            return Disposables.create()
        }
    }
    
    func requestMediaMyList(mode: MediaMode) -> Single<[Media]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            var mediaMyListIDs: [String]?
            
            switch mode {
            case .bright:
                let mediaMyList = realm.objects(BrightMedia.self)
                mediaMyListIDs = try? mediaMyList.compactMap({ element throws in element.id})
            case .darkness:
                let mediaMyList = realm.objects(DarknessMedia.self)
                mediaMyListIDs = try? mediaMyList.compactMap({ element throws in element.id})
            }
            
            guard let ids = mediaMyListIDs else {
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
    
    func requestRecentPlayHistory() -> Single<[Media]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            let playHistoryList = realm.objects(PlayHistory.self)
            let playHistoryIDs = try? playHistoryList.compactMap({ element throws in element.mediaID})
            
            guard let ids = playHistoryIDs else {
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
    
    func requestAllMaximList() -> Single<[Maxim]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            let maximList = realm.objects(Maxim.self)
            let result = try? maximList.compactMap({ element throws in element })
            if let result = result {
                single(.success(result))
            } else {
                single(.failure(RealmError.searchFailed))
            }
            
            return Disposables.create()
        }
    }
    
    func requestFavoriteMaximList() -> Single<[Maxim]> {
        let realm = try? Realm()
        return Single.create { single in
            guard let realm = realm else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            let favoriteMaximList = realm.objects(FavoriteMaxim.self)
            let favoriteMaximIDs = try? favoriteMaximList.compactMap({ element throws in element.id})
            
            guard let ids = favoriteMaximIDs else {
                single(.failure(RealmError.searchFailed))
                return Disposables.create()
            }
            
            let filteredMaxim = realm.objects(Maxim.self).filter("id IN %@", ids)
            let result = try? filteredMaxim.compactMap({ element throws in element})
            if let result = result {
                single(.success(result))
            } else {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }
}

//
//  MyFavoriteRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/17.
//

import Foundation

import RxSwift

final class FavoriteRepository {
    private let localDBManager = RealmDBManager.shared
    
    func create(mediaID: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let newFavorite = FavoriteMedia(mediaID: mediaID)
                try newFavorite.autoIncrease()
                try self.localDBManager.add(newFavorite)
            } catch {
                single(.failure(error))
            }
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func read() -> Single<[Media]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let list = try self.localDBManager.objects(ofType: FavoriteMedia.self)
                
                var favoriteDict: [String: Int] = [:]
                list.forEach { element in
                    favoriteDict[element.mediaID] = element.id
                }
                
                let favoriteIDs = Array(favoriteDict.keys)
                let predicate = NSPredicate.init(format: "id IN %@", favoriteIDs)
                let filteredMedia = try self.localDBManager.objects(ofType: Media.self, with: predicate)
                let result = filteredMedia.sorted {
                    guard let lhs = favoriteDict[$0.id],
                          let rhs = favoriteDict[$1.id]
                    else {
                        return false
                    }
                    return lhs > rhs
                }
                single(.success(result))
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            
            return Disposables.create()
        }
    }
    
    func read(mediaID: String) -> Single<[FavoriteMedia]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let predicate = NSPredicate(format: "mediaID == %@", mediaID)
                let result = try self.localDBManager.objects(
                    ofType: FavoriteMedia.self,
                    with: predicate
                )
                single(.success(result))
            } catch {
                single(.failure(RealmError.searchFailed))
            }
            return Disposables.create()
        }
    }

    func delete(mediaID: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let predicate = NSPredicate(format: "mediaID = %@", mediaID)
                
                let deletingMedia = try self.localDBManager.objects(
                    ofType: FavoriteMedia.self,
                    with: predicate
                ).first
                
                if let deletingMedia = deletingMedia {
                    try self.localDBManager.delete(deletingMedia)
                }
                
                single(.success(true))
            } catch {
                single(.failure(RealmError.deleteFailed))
            }
            return Disposables.create()
        }
    }
}

//
//  PlayHistoryRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/24.
//

import Foundation

import RxSwift

final class PlayHistoryRepository {
    private let localDBManager = RealmDBManager.shared
    
    func create(mediaID: String) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(RealmError.initFailed))
                return Disposables.create()
            }
            
            do {
                let newHistory = PlayHistory(mediaID: mediaID)
                try newHistory.autoIncrease()
                try self.localDBManager.add(newHistory)
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
                let list = try self.localDBManager.searchTest(ofType: PlayHistory.self)
                
                var playHistoryDict: [String: Int] = [:]
                list.forEach { element in
                    playHistoryDict[element.mediaID] = element.id
                }
                
                let playHistoryIDs = Array(playHistoryDict.keys)
                let predicate = NSPredicate.init(format: "id IN %@", playHistoryIDs)
                let filteredMedia = self.localDBManager.searchTest(ofType: Media.self, with: predicate)
                let result = filteredMedia.sorted {
                    guard let lhs = playHistoryDict[$0.id],
                          let rhs = playHistoryDict[$1.id]
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
}

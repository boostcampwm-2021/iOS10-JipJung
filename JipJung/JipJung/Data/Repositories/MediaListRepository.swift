//
//  MediaListRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

final class MediaListRepository: MediaListRepositoryProtocol {
    private let localDBManager: LocalDBManageable
    
    init(localDBManager: LocalDBManageable) {
        self.localDBManager = localDBManager
    }
    
    func fetchAllMediaList() -> Single<[Media]> {
        return localDBManager.requestAllMediaList()
    }
    
    func fetchMediaMyList(mode: MediaMode) -> Single<[Media]> {
        return localDBManager.requestMediaMyList(mode: mode)
    }
    
    func fetchFavoriteMediaList() -> Single<[Media]> {
        return localDBManager.requestFavoriteMediaList()
    }
    
    func fetchRecentPlayHistory() -> Single<[Media]> {
        return localDBManager.requestRecentPlayHistory()
    }
}

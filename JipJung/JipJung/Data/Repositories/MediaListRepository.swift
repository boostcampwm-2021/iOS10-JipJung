//
//  MediaListRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

final class MediaListRepository {
    private let localDBManager: LocalDBManageable
    
    init(localDBManager: LocalDBManageable) {
        self.localDBManager = localDBManager
    }
    
    // TODO: fetchAllMediaList 구현
    
    // TODO: fetchMediaMyList로 변경
    func fetchMediaList(mode: MediaMode?) -> Single<[Media]> {
        return localDBManager.requestMediaList(mode: mode)
    }
    
    func fetchFavoriteMediaList() -> Single<[Media]> {
        return localDBManager.requestFavoriteMediaList()
    }
    
    func fetchRecentPlayHistory() -> Single<[Media]> {
        return localDBManager.requestRecentPlayHistory()
    }
}

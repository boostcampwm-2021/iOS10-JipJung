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
    
    func addPlayHistory(mediaID: String) -> Single<Bool> {
        return localDBManager.createPlayHistory(mediaID: mediaID)
    }
    
    func fetchPlayHistory() -> Single<[Media]> {
        return localDBManager.requestPlayHistory()
    }
}

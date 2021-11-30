//
//  PlayHistoryUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/24.
//

import Foundation

import RxSwift

final class PlayHistoryUseCase {
    private let playHistoryRepository = PlayHistoryRepository()
    
    func addPlayHistory(mediaID: String) -> Single<Bool> {
        return playHistoryRepository.create(mediaID: mediaID)
    }
    
    func fetchPlayHistory() -> Single<[Media]> {
        return playHistoryRepository.read()
    }
}

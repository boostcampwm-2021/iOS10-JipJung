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
    
    func fetchPlayHistory() -> Single<[Media]> {
        return playHistoryRepository.read()
    }
}

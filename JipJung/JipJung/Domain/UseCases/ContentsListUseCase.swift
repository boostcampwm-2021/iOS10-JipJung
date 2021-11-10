//
//  ContentsListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift

class ContentsListUseCase {
    private let mediaListRepository: MediaListRepository
    private let maximListRepository: MaximListRepository
    
    init(
        mediaListRepository: MediaListRepository,
        maximListRepository: MaximListRepository
    ) {
        self.mediaListRepository = mediaListRepository
        self.maximListRepository = maximListRepository
    }
    
    func fetchMediaList(mode: MediaMode?) -> Single<[Media]> {
        return mediaListRepository.fetchMediaList(mode: mode)
    }
    
    func fetchRecentPlayHistory() -> Single<[Media]> {
        return mediaListRepository.fetchRecentPlayHistory()
    }
    
    func fetchFavoriteMediaList() -> Single<[Media]> {
        return mediaListRepository.fetchFavoriteMediaList()
    }
    
    func fetchMaximList() -> Single<[Maxim]> {
        return maximListRepository.fetchMaximList()
    }
    
    func fetchFavoriteMaximList() -> Single<[Maxim]> {
        return maximListRepository.fetchFavoriteMaximList()
    }
}

//
//  MediaListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

final class MediaListUseCase {
    private let mediaListRepository: MediaListRepositoryProtocol
    
    init(mediaListRepository: MediaListRepository) {
        self.mediaListRepository = mediaListRepository
    }
    
    func fetchAllMediaList() -> Single<[Media]> {
        return mediaListRepository.fetchAllMediaList()
    }
    
    func fetchMediaMyList(mode: MediaMode) -> Single<[Media]> {
        return mediaListRepository.fetchMediaMyList(mode: mode)
    }
    
    func fetchRecentPlayHistory() -> Single<[Media]> {
        return mediaListRepository.fetchRecentPlayHistory()
    }
    
    func fetchFavoriteMediaList() -> Single<[Media]> {
        return mediaListRepository.fetchFavoriteMediaList()
    }
}

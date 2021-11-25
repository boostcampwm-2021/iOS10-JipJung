//
//  MediaListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

import RxSwift

final class MediaListUseCase {
    private let mediaListRepository = MediaListRepository()
    
    func fetchAllMediaList() -> Single<[Media]> {
        return mediaListRepository.fetchAllMediaList()
    }
    
    func fetchMediaMyList(mode: MediaMode) -> Single<[Media]> {
        return mediaListRepository.fetchMediaMyList(mode: mode)
    }
    
    func removeMediaFromMode(media: Media) -> Single<Bool> {
        return mediaListRepository.removeMediaFromMode(media: media)
    }
    
    func removeMediaFromMode(id: String, mode: Int) -> Single<Bool> {
        mediaListRepository.removeMediaFromMode(id: id, mode: mode)
    }
    
    func saveMediaFromMode(id: String, mode: Int) -> Single<Bool>  {
        return mediaListRepository.saveMediaFromMode(id: id, mode: mode)
    }
}

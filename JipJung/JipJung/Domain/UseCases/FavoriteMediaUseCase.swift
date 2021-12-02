//
//  FavoriteMediaUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/17.
//

import Foundation

import RxSwift

final class FavoriteUseCase {
    private let myFavoriteRepository: FavoriteRepository = FavoriteRepository()
    
    func read(id: String) -> Single<[FavoriteMedia]> {
        return myFavoriteRepository.read(mediaID: id)
    }
    
    func fetchAll() -> Single<[Media]> {
        return myFavoriteRepository.read()
    }
    
    func save(id: String, date: Date) -> Single<Bool> {
        return myFavoriteRepository.create(mediaID: id)
            .do(onSuccess: { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: ["RefreshType": [RefreshHomeData.favorite]]
                )
            })
    }
    
    func delete(id: String) -> Single<Bool> {
        return myFavoriteRepository.delete(mediaID: id)
            .do(onSuccess: { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: ["RefreshType": [RefreshHomeData.favorite]]
                )
            })
    }
}

//
//  FavoriteMediaUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/17.
//

import Foundation
import RxSwift

final class FavoriteMediaUseCase {
    private let myFavoriteRepository: MyFavoriteRepository = MyFavoriteRepository()
    
    func read(id: String) -> Single<[FavoriteMedia]> {
        return myFavoriteRepository.read(id: id)
    }
    
    func save(id: String, date: Date) -> Single<Bool> {
        let favoriteMedia = FavoriteMedia(id: id, addDate: date)
        return myFavoriteRepository.save(favoriteMedia)
            .do(onSuccess: { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: ["RefreshType": [RefreshHomeData.favorite]]
                )
            })
    }
    
    func delete(id: String) {
        myFavoriteRepository.delete(id: id)
    }
}

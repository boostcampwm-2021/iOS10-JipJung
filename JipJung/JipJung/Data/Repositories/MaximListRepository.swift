//
//  MaximListRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

final class MaximListRepository {
    private let localDBManager: LocalDBManageable
    
    init(localDBManager: LocalDBManageable) {
        self.localDBManager = localDBManager
    }
    
    func fetchMaximList() -> Single<[Maxim]> {
        return localDBManager.requestMaximList()
    }
    
    func fetchFavoriteMaximList() -> Single<[Maxim]> {
        return localDBManager.requestFavoriteMaximList()
    }
}

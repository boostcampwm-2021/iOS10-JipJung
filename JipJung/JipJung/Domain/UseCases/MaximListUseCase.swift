//
//  MaximListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift

class MaximListUseCase {
    private let maximListRepository: MaximListRepository
    
    init(maximListRepository: MaximListRepository) {
        self.maximListRepository = maximListRepository
    }
    
    func fetchAllMaximList() -> Single<[Maxim]> {
        return maximListRepository.fetchAllMaximList()
    }
    
    func fetchFavoriteMaximList() -> Single<[Maxim]> {
        return maximListRepository.fetchFavoriteMaximList()
    }
}
//
//  MaximListRepository.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RxSwift

final class MaximListRepository {
    private let localDBManager = RealmDBManager.shared
    
    func fetchAllMaximList(from date: Date) -> Single<[Maxim]> {
        return localDBManager.search(ofType: Maxim.self, with: NSPredicate(format: "date < %@", date as CVarArg))
    }
    
    func fetchFavoriteMaximList() -> Single<[Maxim]> {
        return localDBManager.requestFavoriteMaximList()
    }
}

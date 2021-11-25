//
//  MaximListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift

final class MaximListUseCase {
    private let maximListRepository: MaximListRepository
    
    init(maximListRepository: MaximListRepository = MaximListRepository()) {
        self.maximListRepository = maximListRepository
    }
    func fetchMaximList() -> Single<[Maxim]> {
        return maximListRepository.fetchAllMaximList(from: makeTomorrow()).map {
            return $0.dropLast($0.count % 7)
        }
    }
    
    private func makeTomorrow() -> Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: [date.year, date.month, date.day + 1].map({"\($0)"}).joined(separator: "-")) ?? Date(timeIntervalSinceNow: 86400)
    }
    
    func fetchFavoriteMaximList() -> Single<[Maxim]> {
        return maximListRepository.fetchFavoriteMaximList()
    }
}

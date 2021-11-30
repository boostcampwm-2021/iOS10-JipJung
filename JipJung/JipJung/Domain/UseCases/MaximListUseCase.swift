//
//  MaximListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift

protocol MaximListRepositoriable {
    func read(from date: Date) -> Single<[Maxim]>
}

final class MaximListUseCase {
    private let maximListRepository: MaximListRepositoriable
    
    init(maximListRepository: MaximListRepositoriable) {
        self.maximListRepository = maximListRepository
    }
    
    func fetchWeeksMaximList() -> Single<[Maxim]> {
        return maximListRepository.read(from: makeTomorrow()).map {
            $0.dropLast($0.count % 7)
        }
        .map {
            $0.sorted { lhs, rhs in
                lhs.date > rhs.date
            }
        }
    }
    
    private func makeTomorrow() -> Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: [date.year, date.month, date.day + 1].map({"\($0)"}).joined(separator: "-")) ?? Date(timeIntervalSinceNow: 86400)
    }
}

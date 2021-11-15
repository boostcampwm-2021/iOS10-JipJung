//
//  SearchHistoryUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation

final class SearchHistoryUseCase {
    private let searchHistoryRepository = SearchHistoryRepository()

    func save(searchHistory: [String]) {
        return searchHistoryRepository.save(searchHistory: searchHistory)
    }
    
    func load() -> [String] {
        return searchHistoryRepository.load()
    }
}

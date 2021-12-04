//
//  SearchHistoryRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation

final class SearchHistoryRepository {
    private let userDefaultStorage = UserDefaultsStorage.shared
    
    func save(searchHistory: [String]) {
        userDefaultStorage.save(for: UserDefaultsKeys.searchHistory,
                                value: searchHistory)
    }
    
    func load() -> [String] {
        guard let searchHistory: [String] = userDefaultStorage.load(
            for: UserDefaultsKeys.searchHistory
        ) else { return [] }
        return searchHistory
    }
}

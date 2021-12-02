//
//  SearchViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation

import RxRelay
import RxSwift

final class SearchViewModel {
    let searchHistory = BehaviorRelay<[String]>(value: [])
    let searchResult = BehaviorRelay<[Media]>(value: [])
    
    private let disposeBag = DisposeBag()
    private let searchHistoryUseCase = SearchHistoryUseCase()
    private let searchMediaUseCase = SearchMediaUseCase()
    
    func saveSearchKeyword(keyword: String) {
        var searchHistoryValue = searchHistoryUseCase.load()
        searchHistoryValue.append(keyword)
        searchHistoryUseCase.save(searchHistoryValue)
        
        searchHistoryValue = searchHistoryValue.reversed()
            .elements(in: 0..<5)
        searchHistory.accept(searchHistoryValue)
    }
    
    func loadSearchHistory() {
        let searchHistoryValue = searchHistoryUseCase.load()
            .reversed()
            .elements(in: 0..<5)
        searchHistory.accept(searchHistoryValue)
    }
    
    func removeSearchHistory(at index: Int) {
        guard self.searchHistory.value.count > index else { return }
        var searchHistoryValue = searchHistoryUseCase.load()
        searchHistoryValue.remove(at: searchHistoryValue.count-1-index)
        searchHistoryUseCase.save(searchHistoryValue)
    }
    
    func search(keyword: String) {
        searchMediaUseCase.searchResult
            .bind { [weak self] in
                self?.searchResult.accept($0)
            }
            .disposed(by: disposeBag)
        
        searchMediaUseCase.search(keyword: keyword)
    }
}

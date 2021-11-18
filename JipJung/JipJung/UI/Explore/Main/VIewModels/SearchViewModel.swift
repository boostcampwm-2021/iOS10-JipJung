//
//  SearchViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation
import RxSwift
import RxRelay

protocol SearchViewModelInput {
    func saveSearchKeyword(keyword: String)
    func loadSearchHistory()
    func removeSearchHistory(at index: Int)
    func search(keyword: String)
}

protocol SearchViewModelOutput {
    var searchHistory: BehaviorRelay<[String]> { get }
    var searchResult: BehaviorRelay<[Media]> { get }
}

final class SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    var searchHistory: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    var searchResult: BehaviorRelay<[Media]> = BehaviorRelay<[Media]>(value: [])
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let searchHistoryUseCase: SearchHistoryUseCase
    private let searchMediaUseCase: SearchMediaUseCase
    
    init(searchHistoryUseCase: SearchHistoryUseCase,
         searchMediaUseCase: SearchMediaUseCase) {
        self.searchHistoryUseCase = searchHistoryUseCase
        self.searchMediaUseCase = searchMediaUseCase
    }

    func saveSearchKeyword(keyword: String) {
        var searchHistoryValue = searchHistoryUseCase.load()
        searchHistoryValue.append(keyword)
        searchHistoryUseCase.save(searchHistoryValue)
        searchHistory.accept(searchHistoryValue)
    }
    
    func loadSearchHistory() {
        let searchHistoryValue = searchHistoryUseCase.load()
        searchHistory.accept(searchHistoryValue)
    }
    
    func removeSearchHistory(at index: Int) {
        guard self.searchHistory.value.count > index else { return }
        var searchHistoryValue = searchHistory.value
        searchHistoryValue.remove(at: index)
        searchHistoryUseCase.save(searchHistoryValue)
        searchHistory.accept(searchHistoryUseCase.load())
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

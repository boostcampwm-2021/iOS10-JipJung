//
//  ExploreViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation

import RxRelay
import RxSwift

final class ExploreViewModel {
    private let searchMediaUseCase = SearchMediaUseCase()
    private let disposeBag = DisposeBag()

    let categoryItems = BehaviorRelay<[Media]>(value: [])
    let soundTagList = SoundTag.allCases
    var selectedTagIndex = 0
    
    func categorize(by tag: String) {
        guard !tag.isEmpty else { return }
        
        searchMediaUseCase.searchResult
            .bind { [weak self] in
                self?.categoryItems.accept($0)
            }
            .disposed(by: disposeBag)
        searchMediaUseCase.search(tag: tag)
    }
}

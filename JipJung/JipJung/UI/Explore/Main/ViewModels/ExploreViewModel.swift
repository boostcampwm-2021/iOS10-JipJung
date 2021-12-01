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
    let categoryItems = BehaviorRelay<[Media]>(value: [])
    let soundTagList: [SoundTag] = SoundTag.allCases
    var selectedTagIndex: Int = 0
    
    private let disposeBag = DisposeBag()
    
    private let searchMediaUseCase: SearchMediaUseCase
    
    init(searchMediaUseCase: SearchMediaUseCase) {
        self.searchMediaUseCase = searchMediaUseCase
    }
    
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

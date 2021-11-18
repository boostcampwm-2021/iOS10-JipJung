//
//  ExploreViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation
import RxSwift
import RxRelay

protocol ExploreViewModelInput {
    func categorize(by tag: String)
}

protocol ExploreViewModelOutput {
    var categoryItems: BehaviorRelay<[Media]> { get }
    var soundTagList: [SoundTag] { get }
}

final class ExploreViewModel: ExploreViewModelInput, ExploreViewModelOutput {
    var categoryItems: BehaviorRelay<[Media]> = BehaviorRelay<[Media]>(value: [])
    var soundTagList: [SoundTag] = SoundTag.allCases
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let searchMediaUseCase: SearchMediaUseCase
    
    init(searchMediaUseCase: SearchMediaUseCase) {
        self.searchMediaUseCase = searchMediaUseCase
    }
    
    func categorize(by tag: String) {
        guard tag.isNotEmpty else { return }
        searchMediaUseCase.searchResult
            .bind { [weak self] in
                self?.categoryItems.accept($0)
            }
            .disposed(by: disposeBag)
        
        searchMediaUseCase.search(tag: tag)
    }
}

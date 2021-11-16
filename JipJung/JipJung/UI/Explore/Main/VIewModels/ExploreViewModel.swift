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
    func search(tag: String)
}

protocol ExploreViewModelOutput {
    var searchResult: BehaviorRelay<[Media]> { get }
}

final class ExploreViewModel: ExploreViewModelInput, ExploreViewModelOutput {
    var searchResult: BehaviorRelay<[Media]> = BehaviorRelay<[Media]>(value: [])
    let souundTagList: [SoundTag] = [SoundTag.all, SoundTag.nature, SoundTag.urban, SoundTag.relax, SoundTag.focus, SoundTag.focus, SoundTag.cafe, SoundTag.cafe, SoundTag.lounge, SoundTag.club]
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let searchMediaUseCase: SearchMediaUseCase
    
    init(searchMediaUseCase: SearchMediaUseCase) {
        self.searchMediaUseCase = searchMediaUseCase
    }
    
    func search(tag: String) {
        guard tag.isNotEmpty else { return }
        searchMediaUseCase.searchResult
            .bind { [weak self] in
                self?.searchResult.accept($0)
            }
            .disposed(by: disposeBag)
        
        searchMediaUseCase.search(tag: tag)
    }
}

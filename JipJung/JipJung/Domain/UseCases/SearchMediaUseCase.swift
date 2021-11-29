//
//  SearchMediaUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation
import RxSwift
import RxRelay

final class SearchMediaUseCase {
    let allMediaList = BehaviorRelay<[Media]>(value: [])
    let searchResult = BehaviorRelay<[Media]>(value: [])
    
    private let mediaListRepository = MediaListRepository()
    private var disposeBag: DisposeBag = DisposeBag()

    func search(keyword: String) {
        allMediaList.bind { [weak self] in
            guard let self = self else { return }
            var searchResult: [Media] = []
            $0.forEach { media in
                if media.name.contains(keyword) {
                    searchResult.append(media)
                }
            }
            self.searchResult.accept(searchResult)
        }
        .disposed(by: disposeBag)
        
        fetchAllMediaList()
    }
    
    func search(tag: String) {
        allMediaList.bind { [weak self] in
            guard let self = self else { return }
            var searchResult: [Media] = []
            $0.forEach { media in
                if media.tag.contains(tag) {
                    searchResult.append(media)
                }
            }
            self.searchResult.accept(searchResult)
        }
        .disposed(by: disposeBag)
        
        fetchAllMediaList()
    }
    
    private func fetchAllMediaList() {
        mediaListRepository.read()
            .subscribe { [weak self] in
                self?.allMediaList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

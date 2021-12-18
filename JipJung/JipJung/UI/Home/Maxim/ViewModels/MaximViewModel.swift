//
//  MaximViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation

import RxRelay
import RxSwift

final class MaximViewModel {
    let maximList = BehaviorRelay<[MaximPresenterObject]>(value: [])
    let isHeaderPresent = BehaviorRelay<Bool>(value: false)
    let imageURLs = BehaviorRelay<[String]>(value: [])
    let selectedDate = BehaviorRelay<Int>(value: 0)
    let jumpedDate = PublishRelay<Int>()
    let jumpedWeek = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    private let maximListUseCase = MaximListUseCase(
        maximListRepository: MaximListRepository()
    )
    
    func fetchMaximList() {
        maximListUseCase.fetchWeeksMaximList()
            .map {
                $0.map {
                    MaximPresenterObject(maxim: $0)
                }
            }
            .subscribe { [weak self] in
                self?.maximList.accept($0)
            }
            .disposed(by: disposeBag)
    }
    
    func presentHeader() {
        isHeaderPresent.accept(true)
    }
    
    func dismissHeader() {
        isHeaderPresent.accept(false)
    }
    
    func scrollDate(to index: Int) {
        let index = compressIndex(index)
        jumpedWeek.accept(index / 7)
        selectedDate.accept(index)
    }
    
    func scrollWeek(to index: Int) {
        let index = (selectedDate.value % 7 + index * 7)
        jumpDate(to: index)
    }
    
    func jumpDate(to index: Int) {
        let index = compressIndex(index)
        jumpedDate.accept(index)
        selectedDate.accept(index)
    }
    
    // 참고:  https://stackoverflow.com/questions/31656642/lesser-than-or-greater-than-in-swift-switch-statement
    private func compressIndex(_ index: Int) -> Int {
        switch index {
        case ..<0:
            return 0
        case maximList.value.count...:
            return maximList.value.count - 1
        default:
            return index
        }
    }
}

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
    let selectedDate = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    
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
    
    func selectDate(with indexPath: IndexPath) {
        selectedDate.accept(indexPath)
    }
    
    func moveNDate(with nDate: Int) {
        if (0..<maximList.value.count) ~= (selectedDate.value.item + nDate) {
            let newSelectedDate = IndexPath(
                item: selectedDate.value.item + nDate,
                section: selectedDate.value.section
            )
            selectedDate.accept(newSelectedDate)
        }
    }
}

//
//  MaximViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation
import RxRelay
import RxSwift

protocol MaximViewModelInput {
    func fetchMaximList()
    func presentHeader()
    func dismissHeader()
    func selectDate(with indexPath: IndexPath)
    func moveNDate(with nDate: Int)
}

protocol MaximViewModelOutput {
    var maximList: BehaviorRelay<[MaximPresenterObject]> { get }
    var isHeaderPresent: PublishRelay<Bool> { get }
    var imageURLs: BehaviorRelay<[String]> { get }
    var selectedDate: BehaviorRelay<IndexPath> { get }
}

final class MaximViewModel: MaximViewModelInput, MaximViewModelOutput {
    let maximList: BehaviorRelay<[MaximPresenterObject]> = BehaviorRelay<[MaximPresenterObject]>(value: [])
    let isHeaderPresent: PublishRelay<Bool> = PublishRelay<Bool>()
    let imageURLs: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    let selectedDate: BehaviorRelay<IndexPath> = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    private var disposeBag: DisposeBag = DisposeBag()
    private let maximListUseCase: MaximListUseCase
    
    init(maximListUseCase: MaximListUseCase = MaximListUseCase()) {
        self.maximListUseCase = maximListUseCase
    }

    func fetchMaximList() {
        maximListUseCase.fetchAllMaximList()
            .map({ $0.map({ MaximPresenterObject(maxim: $0) })})
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
        if 0 <= selectedDate.value.row + nDate && selectedDate.value.row + nDate < maximList.value.count {
            selectedDate.accept(IndexPath(row: selectedDate.value.row + nDate, section: selectedDate.value.section))
        }
    }
}

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
}

protocol MaximViewModelOutput {
    var maximList: BehaviorRelay<[MaximPresenterObject]> { get }
}

final class MaximViewModel: MaximViewModelInput, MaximViewModelOutput {
    let maximList: BehaviorRelay<[MaximPresenterObject]> = BehaviorRelay<[MaximPresenterObject]>(value: [])
    let isHeaderPresent: PublishRelay<Bool> = PublishRelay<Bool>()
    let imageURLs: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    let selectedDay: PublishRelay<IndexPath> = PublishRelay<IndexPath>()
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
}

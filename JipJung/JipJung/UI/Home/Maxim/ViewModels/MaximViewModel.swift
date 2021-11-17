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
}

protocol MaximViewModelOutput {
    var maximLists: BehaviorRelay<[MaximPresenterObject]> { get }
}

final class MaximViewModel: MaximViewModelInput, MaximViewModelOutput {
    let maximLists: BehaviorRelay<[MaximPresenterObject]> = BehaviorRelay<[MaximPresenterObject]>(value: [])
    let imageURLs: BehaviorRelay<[String]> = BehaviorRelay<[String]>(value: [])
    
    private var disposeBag: DisposeBag = DisposeBag()
    private let maximListUseCase: MaximListUseCase
    
    init(maximListUseCase: MaximListUseCase = MaximListUseCase()) {
        self.maximListUseCase = maximListUseCase
    }

    func fetchMaximList() {
        maximListUseCase.fetchAllMaximList()
            .map({ $0.map({ MaximPresenterObject(maxim: $0) })})
            .subscribe { [weak self] in
                self?.maximLists.accept($0)
            }
            .disposed(by: disposeBag)
    }
}

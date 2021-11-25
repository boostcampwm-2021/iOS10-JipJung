//
//  PlayHistoryViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/25.
//

import Foundation

import RxRelay
import RxSwift

final class PlayHistoryViewModel {
    private let playHistoryUseCase = PlayHistoryUseCase()
    private let disposeBag = DisposeBag()
    
    let playHistory = BehaviorRelay<[Media]>(value: [])
    
    func viewDidLoad() {
        playHistoryUseCase.fetchPlayHistory()
            .subscribe { [weak self] in
                print($0.count)
                self?.playHistory.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

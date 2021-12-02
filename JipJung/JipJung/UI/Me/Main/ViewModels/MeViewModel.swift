//
//  MeViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation

import RxSwift
import RxRelay

final class MeViewModel {
    let grassPresenterObject = BehaviorRelay<GrassPresenterObject?>(value: nil)
    let monthIndex = BehaviorRelay<[(index: Int, month: String)]>(value: [])
    
    private let disposeBag = DisposeBag()
    private let loadFocusTimeUseCase = LoadFocusTimeUseCase()
    
    func fetchFocusTimeLists() {
        let nDay = MeGrassMap.dayCount - 7 + Date().weekday
        let historyObservable = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: nDay)
        historyObservable.bind { [weak self] in
            let grassPresenterObject = GrassPresenterObject(dailyFocusTimes: $0, nDay: nDay)
            self?.grassPresenterObject.accept(grassPresenterObject)
        }
        .disposed(by: disposeBag)
        
        historyObservable
            .flatMap {
                return Observable.from($0.enumerated())
            }
            .filter {
                $0.offset % 7 == 0
            }
            .distinctUntilChanged {
                $0.element.date.month
            }
            .map {
                (index: $0.offset / 7, month: "\($0.element.date.month)월")
            }
            .toArray()
            .asObservable()
            .bind(to: monthIndex)
            .disposed(by: disposeBag)
    }
}

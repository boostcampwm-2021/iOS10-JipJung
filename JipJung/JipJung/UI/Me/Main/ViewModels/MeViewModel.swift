//
//  MeViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation
import RxSwift
import RxRelay

protocol MeViewModelInput {
}

protocol MeViewModelOutput {
    var grassPresenterObject: BehaviorRelay<GrassPresenterObject?> { get }

}

final class MeViewModel: MeViewModelInput, MeViewModelOutput {
    var grassPresenterObject: BehaviorRelay<GrassPresenterObject?> = BehaviorRelay<GrassPresenterObject?>(value: nil)
    var monthIndex: BehaviorRelay<[(index: Int, month: String)]> = BehaviorRelay<[(index: Int, month: String)]>(value: [])
    private var disposeBag: DisposeBag = DisposeBag()
    private let loadFocusTimeUseCase: LoadFocusTimeUseCase
    
    init(loadFocusTimeUseCase: LoadFocusTimeUseCase = LoadFocusTimeUseCase()) {
        self.loadFocusTimeUseCase = loadFocusTimeUseCase
    }
    
    func fetchFocusTimeLists() {
        let nDay = MeGrassMap.dayCount - 7 + Date().weekday
        let historyObservable = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: nDay)
        historyObservable.bind { [weak self] in
            let grassPresenterObject = GrassPresenterObject(dailyFocusTimes: $0, nDay: nDay)
            self?.grassPresenterObject.accept(grassPresenterObject)
        }
        .disposed(by: disposeBag)
        
        // MARK: Month의 변경날짜의 index를 알기 위함
        historyObservable.flatMap({
            return Observable.from($0.enumerated())
        })
            .filter({
                $0.offset % 7 == 0
            })
            .distinctUntilChanged({ $0.element.date.month
            })
            .map({(index: $0.offset / 7, month: "\($0.element.date.month)월") })
            .toArray()
            .asObservable()
            .bind(to: monthIndex)
            .disposed(by: disposeBag)
    }
}

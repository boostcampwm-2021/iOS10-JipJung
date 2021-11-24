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
    
    private var disposeBag: DisposeBag = DisposeBag()
    private let loadFocusTimeUseCase: LoadFocusTimeUseCase
    
    init(loadFocusTimeUseCase: LoadFocusTimeUseCase = LoadFocusTimeUseCase()) {
        self.loadFocusTimeUseCase = loadFocusTimeUseCase
    }
    
    func fetchFocusTimeLists() {
        let nDay = MeGrassMap.dayCount - 7 + Date().weekday
        let historySingleObservable = loadFocusTimeUseCase.loadHistory(from: Date(), nDays: nDay)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        historySingleObservable.subscribe { [weak self] in
            let grassPresenterObject = GrassPresenterObject(dailyFocusTimes: $0, nDay: nDay)
            self?.grassPresenterObject.accept(grassPresenterObject)
        } onFailure: {
            print($0)
        }
        .disposed(by: disposeBag)

        loadFocusTimeUseCase.loadHistory(from: Date(), nDays: 10).subscribe {
            print($0)
        } onFailure: {
            print($0)
        }.disposed(by: disposeBag)
    }
}

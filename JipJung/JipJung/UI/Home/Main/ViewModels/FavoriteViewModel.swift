//
//  FavoriteViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/25.
//

import Foundation

import RxRelay
import RxSwift

final class FavoriteViewModel {
    private let favoriteMediaUseCase = FavoriteMediaUseCase()
    private let disposeBag = DisposeBag()
    
    let favoriteSoundList = BehaviorRelay<[Media]>(value: [])
    
    func viewDidLoad() {
        favoriteMediaUseCase.fetchAll()
            .subscribe { [weak self] in
                self?.favoriteSoundList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

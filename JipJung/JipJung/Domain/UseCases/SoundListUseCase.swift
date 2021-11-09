//
//  SoundListUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift

class SoundListUseCase {
    func fetchModeSoundList(mode: SoundMode) -> Single<[String]> {
        return Single<[String]>.create { single in
            single(.success(["C1", "C2", "C3", "C4"]))
            return Disposables.create()
        }
    }
    
    func fetchFavoriteSoundList() -> Single<[String]> {
        return Single<[String]>.create { single in
            single(.success(["F1", "F2", "F3", "F4"]))
            return Disposables.create()
        }
    }
    
    func fetchRecentPlayHistory() -> Single<[String]> {
        return Single<[String]>.create { single in
            single(.success(["H1", "H2", "H3", "H4"]))
            return Disposables.create()
        }
    }
}
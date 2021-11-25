//
//  MyFavoriteRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/17.
//

import Foundation
import RxSwift

final class MyFavoriteRepository {
    private let localDBManager = RealmDBManager.shared
    private var disposeBag: DisposeBag = DisposeBag()
    
    func save(_ favoriteMedia: FavoriteMedia) -> Single<Bool> {
        return localDBManager.write(favoriteMedia)
    }
    
    func read(id: String) -> Single<[FavoriteMedia]> {
        let predicate = NSPredicate(format: "id == %@", id)
        return localDBManager.search(ofType: FavoriteMedia.self, with: predicate)
    }

    // MARK: - Todo: Single<Bool>을 리턴하는 형태로 개선 필요
    func delete(id: String) {
        read(id: id)
            .subscribe { [weak self] in
                guard let self = self else { return }
                $0.forEach { favoriteMedia in
                    self.localDBManager.delete(favoriteMedia)
                        .subscribe { _ in
                            NotificationCenter.default.post(
                                name: .refreshHome,
                                object: nil,
                                userInfo: ["RefreshType": [RefreshHomeData.favorite]]
                            )
                        } onFailure: { error in
                            print(error.localizedDescription)
                        }
                        .disposed(by: self.disposeBag)
                }
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

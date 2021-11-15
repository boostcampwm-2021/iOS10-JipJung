//
//  FocusTimeRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation
import RxSwift

protocol FocusTimeRepositoryProtocol {
    func save(record: FocusRecord) -> Single<Bool>
}

final class FocusTimeRepository: FocusTimeRepositoryProtocol {
    private let realmDBManager = RealmDBManager.shared
    private var disposeBag: DisposeBag = DisposeBag()
    
    func save(record: FocusRecord) -> Single<Bool> {
        return realmDBManager.write(record) 
    }
}

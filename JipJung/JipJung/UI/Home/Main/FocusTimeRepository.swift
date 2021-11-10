//
//  FocusTimeRepository.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation
import RxSwift

protocol FucusTimeRepositoryProtocol {
    func save(record: FocusRecord) -> Single<Bool>
}

final class FocusTimeRepository: FucusTimeRepositoryProtocol {
    private let realmDBManager: LocalDBManageable
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(realmDBManager: LocalDBManageable) {
        self.realmDBManager = realmDBManager
    }
    
    func save(record: FocusRecord) -> Single<Bool> {
        return realmDBManager.write(record) 
    }
}

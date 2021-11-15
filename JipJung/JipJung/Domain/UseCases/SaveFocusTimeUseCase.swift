//
//  SaveFocusTimeUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation
import RxSwift

protocol SaveFocusTimeUseCaseProtocol {
    func execute(seconds time: Int) -> Single<Bool>
}

final class SaveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol {
    private let focusTimeRepository: FocusTimeRepositoryProtocol
    
    init(focusTimeRepository: FocusTimeRepositoryProtocol) {
        self.focusTimeRepository = focusTimeRepository
    }
    
    func execute(seconds time: Int) -> Single<Bool> {
        let currentDate = Date()
        return focusTimeRepository.save(record: FocusRecord(id: UUID().uuidString,
                                                            focusTime: time,
                                                            year: currentDate.year,
                                                            month: currentDate.month,
                                                            day: currentDate.day,
                                                            hour: currentDate.hour))
    }
}

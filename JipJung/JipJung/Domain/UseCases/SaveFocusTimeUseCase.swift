//
//  SaveFocusTimeUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

import RxSwift

final class SaveFocusTimeUseCase {
    private let focusTimeRepository = FocusTimeRepository()
    
    func execute(seconds time: Int) -> Single<Bool> {
        let currentDate = Date()
        return focusTimeRepository.create(
            record: FocusRecord(
                id: UUID().uuidString,
                focusTime: time,
                year: currentDate.year,
                month: currentDate.month,
                day: currentDate.day,
                hour: currentDate.hour
            )
        )
    }
}

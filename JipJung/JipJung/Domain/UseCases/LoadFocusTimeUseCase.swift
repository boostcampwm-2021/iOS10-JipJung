//
//  LoadFocusTimeUseCase.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/23.
//

import Foundation
import RxSwift

final class LoadFocusTimeUseCase {
    private let focusTimeRepository: FocusTimeRepositoryProtocol
    
    init(focusTimeRepository: FocusTimeRepositoryProtocol = FocusTimeRepository()) {
        self.focusTimeRepository = focusTimeRepository
    }
    
    func loadHistory(from date: Date, nDays: Int) -> Observable<[DateFocusRecordDTO]> {
        let oneDay = TimeInterval(86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dateObservable = Observable.from(Array(0..<nDays))
            .map({ date.addingTimeInterval(-oneDay * Double($0)) })
        let focusRecordObservable = dateObservable.flatMap { self.focusTimeRepository.load(date: $0) }
        return Observable.zip(dateObservable, focusRecordObservable)
            .map { date, focusRecords -> DateFocusRecordDTO in
                let focusSecond = focusRecords.reduce(0) { $0 + $1.focusTime }
                return DateFocusRecordDTO(date: date, focusSecond: focusSecond)
            }
            .toArray()
            .map({$0.sorted(by: <)})
            .asObservable()
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

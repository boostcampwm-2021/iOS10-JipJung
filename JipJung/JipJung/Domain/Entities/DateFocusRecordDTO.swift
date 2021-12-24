//
//  DateFocusRecordDTO.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/24.
//

import Foundation

struct DateFocusRecordDTO: Comparable {
    static func < (lhs: DateFocusRecordDTO, rhs: DateFocusRecordDTO) -> Bool {
        return lhs.date < rhs.date
    }
    
    let date: Date
    let focusSecond: Int
    
    internal init(date: Date, focusSecond: Int) {
        self.date = date.midnight
        self.focusSecond = focusSecond
    }
}

extension Date {
    var midnight: Date {
        Calendar.current.startOfDay(for: self)
    }
}

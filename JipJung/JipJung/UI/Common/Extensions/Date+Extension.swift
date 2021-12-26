//
//  Date+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

extension Date {
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var weekdayEng: String {
        return ["S", "M", "T", "W", "T", "F", "S"] [weekday - 1]
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}

extension Date {
    var midnight: Date {
        Calendar.current.startOfDay(for: self)
    }
}

extension Date {
    var realmId: String {
        "\(year)\(month)\(day)"
    }
}


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
    
    var weekday: String {
        return ["S", "M", "T", "W", "T", "F", "S"] [Calendar.current.component(.weekday, from: self) - 1]
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}

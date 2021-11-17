//
//  MaximPresenterObject.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/17.
//

import Foundation

struct MaximPresenterObject {
    let day: String
    let monthYear: String
    let content: String
    let speaker: String
    
    init(day: String, monthYear: String, content: String, speaker: String) {
        self.day = day
        self.monthYear = monthYear
        self.content = content
        self.speaker = speaker
    }
    
    init(maxim: Maxim) {
        let monthDict = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        let date = maxim.date
        let day = "\(date.day)"
        let monthYear = "\(monthDict[date.month - 1]) \(date.year)"
        let content = maxim.content
        let speaker = maxim.speaker == "" ? "미상" : maxim.speaker
        self.init(day: day, monthYear: monthYear, content: content, speaker: speaker)
    }
}


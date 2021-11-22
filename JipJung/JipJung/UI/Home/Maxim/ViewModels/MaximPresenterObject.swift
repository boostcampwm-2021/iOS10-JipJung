//
//  MaximPresenterObject.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/17.
//

import Foundation

struct MaximPresenterObject {
    let day: String
    let weekDay: String
    let monthYear: String
    let content: String
    let speaker: String
    let thumbnailImageAssetPath: String
    
    init(day: String, weekDay: String, monthYear: String, content: String, speaker: String, thumbnailImageAssetPath: String) {
        self.day = day
        self.weekDay = weekDay
        self.monthYear = monthYear
        self.content = content
        self.speaker = speaker
        self.thumbnailImageAssetPath = thumbnailImageAssetPath
    }
    
    init(maxim: Maxim) {
        let monthList = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        let date = maxim.date
        let day = "\(date.day)"
        let weekDay = "\(date.weekday)"
        let monthYear = "\(monthList[date.month - 1]) \(date.year)"
        let content = maxim.content
        let speaker = maxim.speaker.isEmpty ? "미상" : maxim.speaker
        let thumbnailImageAssetPath = maxim.id + ".jpg"
        self.init(day: day, weekDay: weekDay, monthYear: monthYear, content: content, speaker: speaker, thumbnailImageAssetPath: thumbnailImageAssetPath)
    }
}


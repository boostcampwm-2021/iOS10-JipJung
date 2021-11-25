//
//  GrassPresenterObject.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/24.
//

import Foundation

struct GrassPresenterObject {
    internal init(totalFocusMinute: String, averageFocusMinute: String, statisticsPeriod: String, stageList: [FocusStage]) {
        self.totalFocusMinute = totalFocusMinute
        self.averageFocusMinute = averageFocusMinute
        self.statisticsPeriod = statisticsPeriod
        self.stageList = stageList
    }
    
    let totalFocusMinute: String
    let averageFocusMinute: String
    let statisticsPeriod: String
    let stageList: [FocusStage]
    
    init(dailyFocusTimes: [DateFocusRecordDTO], nDay: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let minute = 60
        let totalFocusMinute = dailyFocusTimes.reduce(0) { $0 + $1.focusSecond } / minute
        let averageFocusMinute = (Float(totalFocusMinute) / Float(nDay) * 100.0).rounded() / 100.0
        
        let maxFocusTime = dailyFocusTimes.max(by: {$0.focusSecond < $1.focusSecond})?.focusSecond ?? Int.max
        // MARK: 0 ~ 1의 범위를 0.2 ~ 1로 만들기 위한 함수
        let stageList = dailyFocusTimes.map { FocusStage.makeFocusStage(withSecond: $0.focusSecond)}
        let firstDate = dailyFocusTimes.first?.date ?? Date(timeIntervalSince1970: 0)
        let lastDate = dailyFocusTimes.last?.date ?? Date()
        let statisticsPeriod = [dateFormatter.string(from: firstDate), dateFormatter.string(from: lastDate)]
            .joined(separator: " ~ ")
        self.init(
            totalFocusMinute: "\(totalFocusMinute)",
            averageFocusMinute: "\(averageFocusMinute)",
            statisticsPeriod: statisticsPeriod,
            stageList: stageList)
    }
}

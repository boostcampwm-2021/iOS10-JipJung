//
//  GrassPresenterObject.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/24.
//

import Foundation

struct GrassPresenterObject {
    init(totalFocusHour: String, averageFocusHour: String, statisticsPeriod: String, stageList: [FocusStage]) {
        self.totalFocusHour = totalFocusHour
        self.averageFocusHour = averageFocusHour
        self.statisticsPeriod = statisticsPeriod
        self.stageList = stageList
    }
    
    let totalFocusHour: String
    let averageFocusHour: String
    let statisticsPeriod: String
    let stageList: [FocusStage]
    
    init(dailyFocusTimes: [DateFocusRecordDTO], nDay: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let hourSecond = 3600.0
        let totalFocusHour = Double((dailyFocusTimes.reduce(0.0) { $0 + Double($1.focusSecond) } / hourSecond * 10000.0)).rounded() / 10000.0
        let averageFocusHour = (Double(totalFocusHour) / Double(nDay) * 100.0).rounded() / 100.0
        
        let maxFocusTime = dailyFocusTimes.max(by: {$0.focusSecond < $1.focusSecond})?.focusSecond ?? Int.max
        // MARK: 0 ~ 1의 범위를 0.2 ~ 1로 만들기 위한 함수
        let stageList = dailyFocusTimes.map { FocusStage.makeFocusStage(withSecond: $0.focusSecond)}
        let firstDate = dailyFocusTimes.first?.date ?? Date(timeIntervalSince1970: 0)
        let lastDate = dailyFocusTimes.last?.date ?? Date()
        let statisticsPeriod = [dateFormatter.string(from: firstDate), dateFormatter.string(from: lastDate)]
            .joined(separator: " ~ ")
        self.init(
            totalFocusHour: "\(totalFocusHour)",
            averageFocusHour: "\(averageFocusHour)",
            statisticsPeriod: statisticsPeriod,
            stageList: stageList)
    }
}

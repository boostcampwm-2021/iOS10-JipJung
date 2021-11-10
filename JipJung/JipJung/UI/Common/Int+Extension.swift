//
//  Int+Extension.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

extension Int {
    var digitalClockFormatted: String {
        let minutes = self / 60
        let seconds = self - (minutes * 60)
        return String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
}

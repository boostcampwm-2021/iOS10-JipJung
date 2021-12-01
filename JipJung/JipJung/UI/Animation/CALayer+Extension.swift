//
//  CALayer+Extension.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/10.
//

import UIKit

//MARK: - 출처: https://stackoverflow.com/questions/33994520/how-to-pause-and-resume-uiview-animatewithduration

extension CALayer {
    func pauseLayer() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }

    func resumeLayer() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}

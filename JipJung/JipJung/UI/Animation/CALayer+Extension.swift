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
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }

    func resumeLayer() {
        let pausedTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}

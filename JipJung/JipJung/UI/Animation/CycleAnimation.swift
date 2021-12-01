//
//  CycleAnimation.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import QuartzCore

final class CycleAnimation: CABasicAnimation {
    override init() {
        super.init()
        self.cycleAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.cycleAnimation()
    }
    
    private func cycleAnimation() {
        keyPath = "transform.rotation"
        fromValue = 0.0
        toValue = Double.pi * 2
        duration = 31
        repeatCount = .greatestFiniteMagnitude
    }
}

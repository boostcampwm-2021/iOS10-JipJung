//
//  PulseAnimation.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/10.
//

import UIKit

class PulseAnimation: CAAnimationGroup {
    override init() {
        super.init()
        self.scaleAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scaleAnimation()
    }
    
    private func scaleAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.6
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0
        
        self.animations = [scaleAnimation, opacityAnimation]
        self.duration = 4
        self.repeatCount = .greatestFiniteMagnitude
        self.timingFunction = CAMediaTimingFunction(name: .easeOut)
    }
}

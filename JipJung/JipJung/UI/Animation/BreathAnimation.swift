//
//  BreathAnimation.swift
//  JipJung
//
//  Created by turu on 2021/11/18.
//

import UIKit

class BreathAnimation: CAAnimationGroup {
    private override init() {
        super.init()
//        self.atypicalAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func atypicalAnimation(frame: CGRect) {
        let (bezPathStage0, bezPathStage1, bezPathStage2) = prepareBezierPath(frame: frame)
        
        let animStage0: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animStage0.fromValue = bezPathStage0.cgPath
        animStage0.toValue = bezPathStage1.cgPath
        animStage0.beginTime = 0.0
        animStage0.duration = 2.2

        let animStage1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animStage1.fromValue = bezPathStage1.cgPath
        animStage1.toValue = bezPathStage2.cgPath
        animStage1.beginTime = animStage0.beginTime + animStage0.duration
        animStage1.duration = animStage0.duration

        let animStage2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animStage2.fromValue = bezPathStage2.cgPath
        animStage2.toValue = bezPathStage0.cgPath
        animStage2.beginTime = animStage1.beginTime + animStage1.duration
        animStage2.duration = animStage0.duration

        self.animations = [animStage0, animStage1, animStage2]
        self.duration = animStage2.beginTime + animStage2.duration
        self.fillMode = CAMediaTimingFillMode.forwards
        self.isRemovedOnCompletion = false
        self.repeatCount = Float.infinity
    }

    convenience init(frame: CGRect) {
        self.init()

        atypicalAnimation(frame: frame)
    }
    
    private func prepareBezierPath(frame: CGRect) -> (UIBezierPath, UIBezierPath, UIBezierPath) {
        let rectRef = BreathAnimationFrame(UIView(frame: frame))

        let bezPathStage0: UIBezierPath = UIBezierPath()
        bezPathStage0.move(to: rectRef.bottomLeft)
        bezPathStage0.addCurve(to: rectRef.bottomRight,
                               controlPoint1: CGPoint(x: rectRef.minX + rectRef.length * 0.2,
                                                      y: rectRef.maxY + rectRef.length * 0.3),
                               controlPoint2: CGPoint(x: rectRef.minX + rectRef.length * 0.63,
                                                      y: rectRef.maxY + rectRef.length * 0.41))
        bezPathStage0.addCurve(to: rectRef.topRight,
                               controlPoint1: CGPoint(x: rectRef.maxX + rectRef.length * 0.22,
                                                      y: rectRef.maxY - rectRef.length * 0.29),
                               controlPoint2: CGPoint(x: rectRef.maxX + rectRef.length * 0.23,
                                                      y: rectRef.minY + rectRef.length * 0.4))
        bezPathStage0.addCurve(to: rectRef.topLeft,
                               controlPoint1: CGPoint(x: rectRef.minX + rectRef.length * 0.81,
                                                      y: rectRef.minY - rectRef.length * 0.29),
                               controlPoint2: CGPoint(x: rectRef.minX + rectRef.length * 0.32,
                                                      y: rectRef.minY - rectRef.length * 0.3))
        bezPathStage0.addCurve(to: rectRef.bottomLeft,
                               controlPoint1: CGPoint(x: rectRef.minX - rectRef.length * 0.3,
                                                      y: rectRef.minY + rectRef.length * 0.3),
                               controlPoint2: CGPoint(x: rectRef.minX - rectRef.length * 0.2,
                                                      y: rectRef.minY + rectRef.length * 0.65))
        bezPathStage0.close()

        rectRef.contentView.bounds.size.width *= 1.02
        rectRef.contentView.bounds.size.height *= 0.98
        let bezPathStage1: UIBezierPath = UIBezierPath()
        bezPathStage1.move(to: rectRef.bottomLeft)
        bezPathStage1.addCurve(to: rectRef.bottomRight,
                               controlPoint1: CGPoint(x: rectRef.minX + rectRef.length * 0.2,
                                                      y: rectRef.maxY + rectRef.length * 0.2),
                               controlPoint2: CGPoint(x: rectRef.minX + rectRef.length * 0.8,
                                                      y: rectRef.maxY + rectRef.length * 0.4))
        bezPathStage1.addCurve(to: rectRef.topRight,
                               controlPoint1: CGPoint(x: rectRef.maxX + rectRef.length * 0.2,
                                                      y: rectRef.minY + rectRef.length * 0.71),
                               controlPoint2: CGPoint(x: rectRef.maxX + rectRef.length * 0.2,
                                                      y: rectRef.minY + rectRef.length * 0.2))
        bezPathStage1.addCurve(to: rectRef.topLeft,
                               controlPoint1: CGPoint(x: rectRef.minX + rectRef.length * 0.6,
                                                      y: rectRef.minY - rectRef.length * 0.4),
                               controlPoint2: CGPoint(x: rectRef.minX + rectRef.length * 0.3,
                                                      y: rectRef.minY - rectRef.length * 0.3))
        bezPathStage1.addCurve(to: rectRef.bottomLeft,
                               controlPoint1: CGPoint(x: rectRef.minX - rectRef.length * 0.33,
                                                      y: rectRef.minY + rectRef.length * 0.4),
                               controlPoint2: CGPoint(x: rectRef.minX - rectRef.length * 0.2,
                                                      y: rectRef.minY + rectRef.length * 0.85))
        bezPathStage1.close()

        rectRef.contentView.transform = CGAffineTransform(rotationAngle: 50)
        rectRef.contentView.bounds.size.width *= 1.0 / 1.02 * 1.01
        rectRef.contentView.bounds.size.height *= 1.0 / 0.98 * 1.0
        rectRef.contentView.bounds.origin.y -= 1.2
        rectRef.contentView.bounds.origin.x -= 1.2
        let bezPathStage2: UIBezierPath = UIBezierPath()
        bezPathStage2.move(to: rectRef.bottomLeft)
        bezPathStage2.addCurve(to: rectRef.bottomRight,
                               controlPoint1: CGPoint(x: rectRef.minX + rectRef.length * 0.18,
                                                      y: rectRef.maxY + rectRef.length * 0.25),
                               controlPoint2: CGPoint(x: rectRef.minX + rectRef.length * 0.75,
                                                      y: rectRef.maxY + rectRef.length * 0.38))
        bezPathStage2.addCurve(to: rectRef.topRight,
                               controlPoint1: CGPoint(x: rectRef.maxX + rectRef.length * 0.21,
                                                      y: rectRef.minY + rectRef.length * 0.73),
                               controlPoint2: CGPoint(x: rectRef.maxX + rectRef.length * 0.22,
                                                      y: rectRef.minY + rectRef.length * 0.3))
        bezPathStage2.addCurve(to: rectRef.topLeft,
                               controlPoint1: CGPoint(x: rectRef.minX + rectRef.length * 0.75,
                                                      y: rectRef.minY - rectRef.length * 0.36),
                               controlPoint2: CGPoint(x: rectRef.minX + rectRef.length * 0.27,
                                                      y: rectRef.minY - rectRef.length * 0.36))
        bezPathStage2.addCurve(to: rectRef.bottomLeft,
                               controlPoint1: CGPoint(x: rectRef.minX - rectRef.length * 0.33,
                                                      y: rectRef.minY + rectRef.length * 0.4),
                               controlPoint2: CGPoint(x: rectRef.minX - rectRef.length * 0.2,
                                                      y: rectRef.minY + rectRef.length * 0.85))
        bezPathStage2.close()
        
        return (bezPathStage0, bezPathStage1, bezPathStage2)
    }
}

// MARK: - 직접 사용하는 View가 아님
struct BreathAnimationFrame {
    var contentView: UIView
    var gap: CGFloat {
        return 0.27
    }
    
    var length: CGFloat {
        return contentView.bounds.maxX * (1 - 2 * gap)
    }

    var maxY: CGFloat {
        return contentView.bounds.maxY * (1 - gap)
    }
    var maxX: CGFloat {
        return contentView.bounds.maxX * (1 - gap)
    }
    var minY: CGFloat {
        return contentView.bounds.maxY * gap
    }
    var minX: CGFloat {
        return contentView.bounds.maxX * gap
    }

    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    var topLeft: CGPoint {
        return CGPoint(x: minX, y: minY)
    }
    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }
    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    init(_ view: UIView) {
        contentView = view
    }
}

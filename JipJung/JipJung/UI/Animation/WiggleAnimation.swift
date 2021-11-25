//
//  WiggleAnimation.swift
//  JipJung
//
//  Created by turu on 2021/11/22.
//

import UIKit

class WiggleAnimation: CAAnimationGroup {
    private override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func atypicalAnimation(frame: CGRect) {
        let (bezierPath0, bezierPath1, bezierPath2) = prepareBezierPaths(frame: frame)
        
        let animation0 = CABasicAnimation(keyPath: "path")
        animation0.fromValue = bezierPath0.cgPath
        animation0.toValue = bezierPath1.cgPath
        animation0.beginTime = 0.0
        animation0.duration = 7.0 / 3.0

        let animation1 = CABasicAnimation(keyPath: "path")
        animation1.fromValue = bezierPath1.cgPath
        animation1.toValue = bezierPath2.cgPath
        animation1.beginTime = animation0.beginTime + animation0.duration
        animation1.duration = animation0.duration

        let animation2 = CABasicAnimation(keyPath: "path")
        animation2.fromValue = bezierPath2.cgPath
        animation2.toValue = bezierPath0.cgPath
        animation2.beginTime = animation1.beginTime + animation1.duration
        animation2.duration = animation0.duration

        self.animations = [animation0, animation1, animation2]
        self.duration = animation2.beginTime + animation2.duration
        self.fillMode = CAMediaTimingFillMode.forwards
        self.isRemovedOnCompletion = false
        self.repeatCount = Float.infinity
    }

    convenience init(frame: CGRect) {
        self.init()

        atypicalAnimation(frame: frame)
    }
    
    private func prepareBezierPaths(frame: CGRect) -> (UIBezierPath, UIBezierPath, UIBezierPath) {
        let box = AtypicalAnimationFrame(UIView(frame: frame))

        let bezierPath0 = UIBezierPath()
        bezierPath0.move(to: box.bottomLeft)
        bezierPath0.addCurve(to: box.bottomRight,
                               controlPoint1: CGPoint(x: box.minX + box.length * 0.2,
                                                      y: box.maxY + box.length * 0.3),
                               controlPoint2: CGPoint(x: box.minX + box.length * 0.63,
                                                      y: box.maxY + box.length * 0.41))
        bezierPath0.addCurve(to: box.topRight,
                               controlPoint1: CGPoint(x: box.maxX + box.length * 0.22,
                                                      y: box.maxY - box.length * 0.29),
                               controlPoint2: CGPoint(x: box.maxX + box.length * 0.23,
                                                      y: box.minY + box.length * 0.4))
        bezierPath0.addCurve(to: box.topLeft,
                               controlPoint1: CGPoint(x: box.minX + box.length * 0.81,
                                                      y: box.minY - box.length * 0.29),
                               controlPoint2: CGPoint(x: box.minX + box.length * 0.32,
                                                      y: box.minY - box.length * 0.3))
        bezierPath0.addCurve(to: box.bottomLeft,
                               controlPoint1: CGPoint(x: box.minX - box.length * 0.3,
                                                      y: box.minY + box.length * 0.3),
                               controlPoint2: CGPoint(x: box.minX - box.length * 0.2,
                                                      y: box.minY + box.length * 0.65))
        bezierPath0.close()

        box.contentView.bounds.size.width *= 1.02
        box.contentView.bounds.size.height *= 0.98
        let bezierPath1 = UIBezierPath()
        bezierPath1.move(to: box.bottomLeft)
        bezierPath1.addCurve(to: box.bottomRight,
                               controlPoint1: CGPoint(x: box.minX + box.length * 0.2,
                                                      y: box.maxY + box.length * 0.2),
                               controlPoint2: CGPoint(x: box.minX + box.length * 0.8,
                                                      y: box.maxY + box.length * 0.4))
        bezierPath1.addCurve(to: box.topRight,
                               controlPoint1: CGPoint(x: box.maxX + box.length * 0.2,
                                                      y: box.minY + box.length * 0.71),
                               controlPoint2: CGPoint(x: box.maxX + box.length * 0.2,
                                                      y: box.minY + box.length * 0.2))
        bezierPath1.addCurve(to: box.topLeft,
                               controlPoint1: CGPoint(x: box.minX + box.length * 0.6,
                                                      y: box.minY - box.length * 0.4),
                               controlPoint2: CGPoint(x: box.minX + box.length * 0.3,
                                                      y: box.minY - box.length * 0.3))
        bezierPath1.addCurve(to: box.bottomLeft,
                               controlPoint1: CGPoint(x: box.minX - box.length * 0.33,
                                                      y: box.minY + box.length * 0.4),
                               controlPoint2: CGPoint(x: box.minX - box.length * 0.2,
                                                      y: box.minY + box.length * 0.85))
        bezierPath1.close()

        box.contentView.transform = CGAffineTransform(rotationAngle: 50)
        box.contentView.bounds.size.width *= 1.0 / 1.02 * 1.01
        box.contentView.bounds.size.height *= 1.0 / 0.98 * 1.0
        box.contentView.bounds.origin.y -= 1.2
        box.contentView.bounds.origin.x -= 1.2
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: box.bottomLeft)
        bezierPath2.addCurve(to: box.bottomRight,
                               controlPoint1: CGPoint(x: box.minX + box.length * 0.18,
                                                      y: box.maxY + box.length * 0.25),
                               controlPoint2: CGPoint(x: box.minX + box.length * 0.75,
                                                      y: box.maxY + box.length * 0.38))
        bezierPath2.addCurve(to: box.topRight,
                               controlPoint1: CGPoint(x: box.maxX + box.length * 0.21,
                                                      y: box.minY + box.length * 0.73),
                               controlPoint2: CGPoint(x: box.maxX + box.length * 0.22,
                                                      y: box.minY + box.length * 0.3))
        bezierPath2.addCurve(to: box.topLeft,
                               controlPoint1: CGPoint(x: box.minX + box.length * 0.75,
                                                      y: box.minY - box.length * 0.36),
                               controlPoint2: CGPoint(x: box.minX + box.length * 0.27,
                                                      y: box.minY - box.length * 0.36))
        bezierPath2.addCurve(to: box.bottomLeft,
                               controlPoint1: CGPoint(x: box.minX - box.length * 0.33,
                                                      y: box.minY + box.length * 0.4),
                               controlPoint2: CGPoint(x: box.minX - box.length * 0.2,
                                                      y: box.minY + box.length * 0.85))
        bezierPath2.close()
        
        return (bezierPath0, bezierPath1, bezierPath2)
    }
}

// MARK: - 직접 사용하는 View가 아님
struct AtypicalAnimationFrame {
    let contentView: UIView
    let gap: CGFloat = 0.27
    
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

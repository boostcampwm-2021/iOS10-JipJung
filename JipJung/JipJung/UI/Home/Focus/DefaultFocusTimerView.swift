//
//  FocusTimerView.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/07.
//

import UIKit

class DefaultFocusTimerView: UIView, FocusTimerViewable {
    enum Size {
        static let circleRadius = 120.0
        static let circleLine = 4.0
    }
    
    enum Color {
        static let pulseCircle = UIColor.systemGray.cgColor
        static let backgroundCircle = UIColor.systemGray.cgColor
        static let progreeCircle = UIColor.systemGray5.cgColor
    }
    
    weak var delegate: FocusTimerViewDelegate?
    private let timeProgressLayer = CAShapeLayer()
    private let pulsesLayer = CALayer()
    private var pulseCreateSupportTimer: Timer?
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시작안함"
        label.textColor = .secondarySystemGroupedBackground
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configurePulse()
        configureBackgroundCircle()
        configureProgressBar()
    }
    
    private func configureBackgroundCircle() {
        let backGroundMaskLayer = CAShapeLayer()
        backGroundMaskLayer.path = UIBezierPath(
            arcCenter: CGPoint(x: center.x, y: center.y - Size.circleRadius / 2),
            radius: Size.circleRadius, startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
        backGroundMaskLayer.fillColor = nil
        backGroundMaskLayer.strokeColor = UIColor.systemGray.cgColor
        backGroundMaskLayer.lineWidth = Size.circleLine
        layer.addSublayer(backGroundMaskLayer)
    }
    
    private func configureProgressBar() {
        let timeProgressPath = UIBezierPath(
            arcCenter: CGPoint(x: center.x, y: center.y - Size.circleRadius / 2),
            radius: Size.circleRadius,
            startAngle: -CGFloat.pi * 0.5,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        timeProgressLayer.fillColor = nil
        timeProgressLayer.path = timeProgressPath.cgPath
        timeProgressLayer.strokeColor = Color.progreeCircle
        timeProgressLayer.lineWidth = 6
        timeProgressLayer.strokeStart = 0
        timeProgressLayer.strokeEnd = 0
        timeProgressLayer.lineCap = .round
        layer.addSublayer(timeProgressLayer)
    }
    
    private func configurePulse() {
        layer.addSublayer(pulsesLayer)
        for _ in 1...4 {
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = UIBezierPath(
                arcCenter: .zero,
                radius: Size.circleRadius, startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            ).cgPath
            pulseLayer.position = CGPoint(x: center.x, y: center.y - Size.circleRadius / 2)
            pulseLayer.fillColor = nil
            pulseLayer.strokeColor = Color.pulseCircle
            pulseLayer.lineWidth = Size.circleLine
            pulsesLayer.addSublayer(pulseLayer)
        }
    }
    
    private func configureUI() {
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }

    func startFocus(with time: String) {
        timeLabel.text = time
        var count = 0
        
        pulseCreateSupportTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            if count >= self?.pulsesLayer.sublayers?.count ?? 0 {
                self?.pulseCreateSupportTimer?.invalidate()
                return
            }
            self?.pulsesLayer.sublayers?[count].add(PulseAnimation(), forKey: nil)
            count += 1
        })
        pulseCreateSupportTimer?.fire()
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 100
        animation.fillMode = .forwards
        timeProgressLayer.add(animation, forKey: "key")
    }
    
    func endFocus() {
        timeLabel.text = "종료"
        timeProgressLayer.removeAllAnimations()
        pulseCreateSupportTimer?.invalidate()
        pulsesLayer.sublayers?.forEach({ $0.removeAllAnimations() })
    }
    
    func changeTime(with time: String) {
        timeLabel.text = time
    }
}

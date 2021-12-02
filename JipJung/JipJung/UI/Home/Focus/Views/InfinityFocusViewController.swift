//
//  InfinityFocusViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/09.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift

final class InfinityFocusViewController: FocusViewController {
    let timerView: UIView = {
        let length = FocusViewControllerSize.timerViewLength
        let size = CGSize(width: length * 1.1, height: length * 1.1)
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        return view
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        return label
    }()
    private lazy var circleShapeLayer: CAShapeLayer = {
        let shapeLayer = createCircleShapeLayer(
            strokeColor: UIColor.systemGray,
            lineWidth: 3
        )
        return shapeLayer
    }()
    private lazy var cometAnimationLayer: CALayer = {
        return createCometCircleShapeLayer(strokeColor: .white, lineWidth: 3)
    }()
    private lazy var pulseGroupLayer = CALayer()
    private lazy var startButton = FocusStartButton()
    private lazy var pauseButton = FocusPauseButton()
    private lazy var continueButton = FocusContinueButton()
    private lazy var exitButton = FocusExitButton()
    
    private let viewModel = InfinityFocusViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTimerUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startButton.alpha = 0
        self.timerView.alpha = 0
        let viewCenter = view.center
        self.timerView.center = CGPoint(x: viewCenter.x, y: viewCenter.y * 0.9)
        UIView.animate(withDuration: 0.6, delay: 0.3, options: []) { [weak self] in
            self?.timerView.alpha = 1
            self?.timerView.center = CGPoint(x: viewCenter.x, y: viewCenter.y * 0.65)
            self?.startButton.alpha = 1
        } completion: { [weak self] in
            if $0 {
                self?.cometAnimationLayer.add(CycleAnimation(), forKey: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let viewCenter = view.center
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.timerView.center = viewCenter
            self?.startButton.alpha = 0
        }
    }

    private func configureTimerUI() {
        view.addSubview(timerView)
        timerView.layer.addSublayer(pulseGroupLayer)
        let pulseCount = 4
        for _ in 0..<pulseCount {
            let pulseLayer = createCircleShapeLayer(strokeColor: .white, lineWidth: 2)
            pulseGroupLayer.addSublayer(pulseLayer)
        }
        
        timerView.layer.addSublayer(circleShapeLayer)
        timerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        timerView.layer.addSublayer(cometAnimationLayer)
    }
    
    private func configureUI() {
        view.makeBlurBackground()
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(FocusViewButtonSize.startButton.width)
            $0.height.equalTo(FocusViewButtonSize.startButton.height)
        }

        view.addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(FocusViewButtonSize.pauseButton.width)
            $0.height.equalTo(FocusViewButtonSize.pauseButton.height)
        }

        view.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(FocusViewButtonSize.continueButton.width)
            $0.height.equalTo(FocusViewButtonSize.continueButton.height)
        }

        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(FocusViewButtonSize.exitButton.width)
            $0.height.equalTo(FocusViewButtonSize.exitButton.height)
        }
    }
    
    private func bindUI() {
        viewModel.timerState.bind(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .ready:
                    self.presentReady()
                case .running(_):
                    self.viewModel.startClockTimer()
                    self.presentRunning()
                case .paused:
                    self.viewModel.pauseClockTimer()
                    self.presentPaused()
                }
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.changeTimerState(to: .running(isResume: false))
            }
            .disposed(by: disposeBag)
        
        pauseButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.changeTimerState(to: .paused)
            }
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.changeTimerState(to: .running(isResume: true))
            }
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel.alertNotification()
                self.viewModel.changeTimerState(to: .ready)
                self.viewModel.resetClockTimer()
                self.viewModel.saveFocusRecord()
            }
            .disposed(by: disposeBag)
        
        viewModel.clockTime
            .bind(onNext: { [weak self] in
                guard let self = self, $0 > 0 else { return }
                self.timeLabel.text = $0.digitalClockFormatted
                self.startPulseAnimation(second: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentReady() {
        pauseButton.isHidden = true
        timeLabel.text = 0.digitalClockFormatted
        removePulseAnimation()
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.continueButton.frame = CGRect(
                x: self.startButton.frame.minX,
                y: self.continueButton.frame.minY,
                width: self.continueButton.frame.width,
                height: self.continueButton.frame.height
            )
            self.exitButton.frame = CGRect(
                x: self.startButton.frame.minX,
                y: self.exitButton.frame.minY,
                width: self.exitButton.frame.width,
                height: self.exitButton.frame.height
            )
        } completion: { _ in
            self.continueButton.isHidden = true
            self.exitButton.isHidden = true
            self.startButton.isHidden = false
        }
    }
    
    private func presentRunning() {
        startButton.isHidden = true
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.continueButton.frame = CGRect(
                x: self.startButton.frame.minX,
                y: self.continueButton.frame.minY,
                width: self.continueButton.frame.width,
                height: self.continueButton.frame.height
            )
            self.exitButton.frame = CGRect(
                x: self.startButton.frame.minX,
                y: self.exitButton.frame.minY,
                width: self.exitButton.frame.width,
                height: self.exitButton.frame.height
            )
        } completion: { _ in
            self.continueButton.isHidden = true
            self.exitButton.isHidden = true
            self.pauseButton.isHidden = false
        }
    }
    
    private func presentPaused() {
        startButton.isHidden = true
        pauseButton.isHidden = true

        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.continueButton.isHidden = false
            self.exitButton.isHidden = false
            self.continueButton.frame = CGRect(
                x: self.continueButton.frame.minX * 0.45,
                y: self.continueButton.frame.minY,
                width: self.continueButton.frame.width,
                height: self.continueButton.frame.height
            )
            self.exitButton.frame = CGRect(
                x: self.exitButton.frame.minX * 1.55,
                y: self.exitButton.frame.minY,
                width: self.exitButton.frame.width,
                height: self.exitButton.frame.height
            )
        }
    }
    
    private func createCircleShapeLayer(
        strokeColor: UIColor,
        lineWidth: CGFloat,
        startAngle: CGFloat = 0,
        endAngle: CGFloat = 2 * CGFloat.pi
    ) -> CAShapeLayer {
        let circleShapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: .zero,
            radius: FocusViewControllerSize.timerViewLength * 0.5,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.strokeColor = strokeColor.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.lineWidth = lineWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.position = timerView.center
        return circleShapeLayer
    }

    private func startPulseAnimation(second: Int) {
        self.pulseGroupLayer.sublayers?[second % 4].add(PulseAnimation(), forKey: "pulse")
    }

    private func removePulseAnimation() {
        pulseGroupLayer.sublayers?.forEach({ $0.removeAllAnimations() })
    }
    
    private func createCometCircleShapeLayer(
        strokeColor: UIColor,
        lineWidth: CGFloat
    ) -> CALayer {
        let circleShapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(
            arcCenter: .zero,
            radius: FocusViewControllerSize.timerViewLength * 0.5,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.strokeColor = UIColor.red.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.lineWidth = lineWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.position = timerView.center
        
        let gradient = CAGradientLayer()
        gradient.frame = timerView.bounds
        gradient.position = timerView.center
        gradient.colors = [UIColor.systemGray.cgColor, strokeColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1)
        gradient.locations = [0.8, 1]
        gradient.type = .conic
        gradient.mask = circleShapeLayer
        return gradient
    }
}

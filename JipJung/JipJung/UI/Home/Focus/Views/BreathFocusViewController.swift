//
//  BreathFocusViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class BreathFocusViewController: FocusViewController {
    // MARK: - Subviews
    private let breathView = UIView()
    
    private lazy var timePickerView: UIPickerView = {
        let timePickerView = UIPickerView()
        timePickerView.delegate = self
        timePickerView.dataSource = self
        return timePickerView
    }()
    
    private lazy var minuteLabel: UILabel = {
        let minuteLabel = UILabel()
        minuteLabel.text = "min"
        minuteLabel.textColor = .init(white: 1.0, alpha: 0.8)
        return minuteLabel
    }()
    
    private lazy var numberOfBreathLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "7 breaths"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 21)
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    private lazy var breathShapeLayer: CAShapeLayer = {
        let drawingLayer = CAShapeLayer()
        drawingLayer.fillColor = .init(red: 0.1, green: 1.0, blue: 0.3, alpha: 0.5)
        drawingLayer.shadowColor = .init(red: 0, green: 1.0, blue: 0, alpha: 1)
        drawingLayer.shadowOpacity = 0.9
        drawingLayer.shadowOffset = CGSize.zero
        drawingLayer.shadowRadius = 20
        return drawingLayer
    }()
    private lazy var scalingShapeLayer: CAShapeLayer = {
        let scalingShapeLayer = CAShapeLayer()
        scalingShapeLayer.fillColor = .init(gray: 0, alpha: 0)
        scalingShapeLayer.strokeColor = UIColor.white.cgColor
        scalingShapeLayer.lineWidth = 2.0
        return scalingShapeLayer
    }()
    private lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.alignmentMode = .center
        textLayer.string = "Inhale"
        return textLayer
    }()
    private let countdownView = CountdownView()
    
    private let startButton = FocusStartButton()
    private let stopButton: FocusExitButton = {
        let stopButton = FocusExitButton()
        stopButton.setTitle("Stop", for: .normal)
        return stopButton
    }()
    
    // MARK: - Private Variables
    
    private var viewModel: BreathFocusViewModel?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startButton.alpha = 0
        breathView.alpha = 0
        let viewCenter = view.center
        breathView.center = CGPoint(x: viewCenter.x, y: viewCenter.y * 0.9)
        UIView.animate(withDuration: 0.6, delay: 0.3, options: []) { [weak self] in
            self?.breathView.alpha = 1
            self?.breathView.center = CGPoint(x: viewCenter.x, y: viewCenter.y * 0.8)
            self?.startButton.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let viewCenter = view.center
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.breathView.center = viewCenter
            self?.startButton.alpha = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        breathShapeLayer.frame = breathView.bounds
        scalingShapeLayer.frame = breathView.bounds
        textLayer.frame = CGRect(origin: CGPoint(x: breathView.bounds.midX - 60,
                                                 y: breathView.bounds.midY - 40),
                                 size: CGSize(width: 120, height: 100))
        startWiggleAnimation()
    }
    
    // MARK: - Initializer
    
    convenience init(viewModel: BreathFocusViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.makeBlurBackground()
        
        view.addSubview(breathView)
        breathView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(breathView.snp.width)
            $0.top.equalTo(super.closeButton.snp.bottom)
        }
        breathView.layer.addSublayer(breathShapeLayer)
        breathView.layer.addSublayer(scalingShapeLayer)
        scalingShapeLayer.addSublayer(textLayer)
        scalingShapeLayer.isHidden = true
        
        view.addSubview(countdownView)
        countdownView.snp.makeConstraints {
            $0.center.equalTo(breathView)
            $0.size.equalTo(breathView).multipliedBy(0.2)
        }
        countdownView.isHidden = true
        
        view.addSubview(numberOfBreathLabel)
        numberOfBreathLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.2)
            $0.centerX.equalToSuperview()
        }
        
        breathView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.center.equalTo(breathView.snp.center)
        }
        
        breathView.addSubview(minuteLabel)
        minuteLabel.snp.makeConstraints {
            $0.centerY.equalTo(timePickerView)
            $0.centerX.equalTo(timePickerView.snp.centerX).offset(60)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(FocusViewButtonSize.startButton.width)
            $0.height.equalTo(FocusViewButtonSize.startButton.height)
        }
        
        view.addSubview(stopButton)
        stopButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(FocusViewButtonSize.pauseButton.width)
            $0.height.equalTo(FocusViewButtonSize.pauseButton.height)
        }
        stopButton.isHidden = true
    }
    
    private func bindUI() {
        startButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.changeState(to: .running)
            }
            .disposed(by: disposeBag)
        
        stopButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.changeState(to: .stop)
            }
            .disposed(by: disposeBag)
        
        viewModel?.focusState
            .skip(1)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .running:
                    self.startBreath()
                case .stop:
                    self.alertNotification()
                    self.stopBreath()
                    self.viewModel?.saveFocusRecord()
                    self.viewModel?.resetClockTimer()
                }
            }).disposed(by: disposeBag)
        
        viewModel?.clockTime.bind(onNext: { [weak self] in
            guard let self = self else { return }
            if $0 % 7 == 3 {
                self.textLayer.opacity = 0
                self.textLayer.string = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.textLayer.string = "Exhale"
                    self.textLayer.opacity = 1
                }
            } else if $0 % 7 == 6 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 - 0.25) {
                    self.textLayer.string = ""
                    self.textLayer.opacity = 0
                }
            } else if $0 % 7 == 0 {
                self.textLayer.string = "Inhale"
                self.textLayer.opacity = 1
                
                UIView.animate(withDuration: 4.0,
                               delay: 0.0,
                               options: .allowUserInteraction,
                               animations: {
                    self.view.layer.backgroundColor = .init(red: 129.0 / 255.0,
                                                            green: 240.0 / 255.0,
                                                            blue: 135.0 / 255.0,
                                                            alpha: 0.8)
                },
                               completion: nil)
            } else if $0 % 7 == 4 {
                UIView.animate(withDuration: 3.0,
                               delay: 0.0,
                               options: .allowUserInteraction,
                               animations: {
                    self.view.layer.backgroundColor = .init(red: 131.0 / 255.0,
                                                            green: 79.0 / 255.0,
                                                            blue: 163.0 / 255.0,
                                                            alpha: 0.3)
                },
                               completion: nil)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func alertNotification() {
        guard let clockTime = self.viewModel?.clockTime.value else {
            return
        }
        let angryEmpjis = ["😡", "🤬", "🥵", "🥶", "😰"]
        let happyEmojis = ["☺️", "😘", "😍", "🥳", "🤩"]
        let times = clockTime / 7
        let message = times > 0
        ? "\(clockTime / 7)회 호흡 운동하셨습니다." + (happyEmojis.randomElement() ?? "")
        : "\(times)회... 반복했습니다. 집중합시다!" + (angryEmpjis.randomElement() ?? "")
        PushNotificationMananger.shared.presentFocusStopNotification(title: .focusFinish,
                                                                     body: message)
        FeedbackGenerator.shared.impactOccurred()
    }
    
    private func startBreath() {
        startButton.isHidden = true
        stopButton.isHidden = false
        numberOfBreathLabel.isHidden = true
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
        
        startIntroAnimation()
        
        // 진입 배경 애니메이션 연결 처리
        self.stopButton.layer.opacity = 0
        UIView.animate(withDuration: 0.4, delay: .zero, options: .curveEaseIn) {
            self.view.layer.backgroundColor = .init(red: 0.1, green: 1.0, blue: 0.3, alpha: 1)
        } completion: { _ in
            // 진입 완료 후 배경색 삭제
            self.breathShapeLayer.isHidden = true
            UIView.animate(withDuration: 3) {
                self.view.layer.backgroundColor = .none
            }
            
            // TODO: 버튼 동시 클릭 문제 해결, 버튼 나타나는 타이밍 조정하기
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                UIView.animate(withDuration: 2.0, delay: .zero, options: .allowUserInteraction) {
                    self.stopButton.layer.opacity = 1
                }
            }
            // 카운트 다운 시작
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.countdownView.isHidden = false
                self.countdownView.animate(countdown: 3) {
                    self.countdownView.isHidden = true
                    self.scalingShapeLayer.isHidden = false
                    self.startInhaleExhaleAnimation()
                    self.viewModel?.startClockTimer()
                }
            }
        }
        
    }
    
    private func stopBreath() {
        startButton.isHidden = false
        stopButton.isHidden = true
        numberOfBreathLabel.isHidden = false
        timePickerView.isHidden = false
        minuteLabel.isHidden = false
        breathShapeLayer.isHidden = false
        
        UIView.animate(withDuration: 1.0) {
            self.view.layer.backgroundColor = .none
            self.scalingShapeLayer.removeAllAnimations()
            self.scalingShapeLayer.isHidden = true
        }
    }
    
    private func startIntroAnimation() {
        let scaleUpAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleUpAnimation.fromValue = 1.0
        scaleUpAnimation.toValue = 5.0
        
        let opacityDownAnimation = CABasicAnimation(keyPath: "opacity")
        opacityDownAnimation.fromValue = 1.0
        opacityDownAnimation.toValue = 0.5
        
        let introAnimations = CAAnimationGroup()
        introAnimations.animations = [scaleUpAnimation, opacityDownAnimation]
        introAnimations.repeatCount = 1
        introAnimations.duration = 0.5
        introAnimations.beginTime = 0.0
        introAnimations.isRemovedOnCompletion = true
        breathShapeLayer.add(introAnimations, forKey: "scaleUpAndOpacityDown")
    }
    
    private func startWiggleAnimation() {
        breathShapeLayer.add(
            WiggleAnimation(frame: breathView.bounds),
            forKey: "wiggle"
        )
    }
    
    private func startInhaleExhaleAnimation() {
        print(#function, #line)
        let animations = WiggleAnimation(frame: breathView.bounds)
        
        let inhaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        inhaleAnimation.fromValue = 0.5
        inhaleAnimation.toValue = 1
        inhaleAnimation.beginTime = animations.beginTime
        inhaleAnimation.duration = animations.duration / 7.0 * 4.0
        inhaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let exhaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        exhaleAnimation.fromValue = 1
        exhaleAnimation.toValue = 0.5
        exhaleAnimation.beginTime = animations.beginTime + animations.duration / 7.0 * 4.0
        exhaleAnimation.duration = animations.duration / 7.0 * 3.0
        exhaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animations.isRemovedOnCompletion = true
        animations.repeatCount = Float(viewModel?.focusTime ?? 1)
        animations.animations?.append(inhaleAnimation)
        animations.animations?.append(exhaleAnimation)
        animations.delegate = self
        scalingShapeLayer.add(animations, forKey: "inhaleAndExhale")
    }
}

extension BreathFocusViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let focusTime = (viewModel?.focusTimeList[row] ?? 0) * 7
        viewModel?.setFocusTime(seconds: focusTime)
        self.numberOfBreathLabel.text = "\(focusTime) breaths"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let minuteInfo = viewModel?.focusTimeList[row] else { return UILabel() }
        timePickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        var pickerLabel: UILabel = UILabel()
        pickerLabel = UILabel()
        pickerLabel.text = "\(minuteInfo)"
        pickerLabel.textColor = UIColor.white
        pickerLabel.font = UIFont.systemFont(ofSize: 35)
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
}

extension BreathFocusViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.focusTimeList.count ?? 0
    }
}
extension BreathFocusViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        viewModel?.changeState(to: .stop)
    }
}

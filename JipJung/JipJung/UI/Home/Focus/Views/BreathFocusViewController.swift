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
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "7 breaths"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 21)
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    private let breathView = UIView()
    private lazy var breathShapeLayer: CAShapeLayer = {
        let drawingLayer = CAShapeLayer()
//        drawingLayer.path = bezPathStage0.cgPath
        drawingLayer.fillColor = .init(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.5)
//        drawingLayer.lineWidth = 4.0
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
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.tintColor = .gray
        let playImage = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        startButton.setImage(playImage, for: .normal)
        startButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        startButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        startButton.setTitleColor(UIColor.gray, for: .normal)
        startButton.layer.cornerRadius = 25
        startButton.backgroundColor = .white
        return startButton
    }()
    
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        stopButton.setTitle("Pause", for: .normal)
        stopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        stopButton.setTitleColor(UIColor.white, for: .normal)
        stopButton.layer.cornerRadius = 25
        stopButton.backgroundColor = .lightGray
        stopButton.layer.borderColor = UIColor.white.cgColor
        stopButton.layer.borderWidth = 2
        return stopButton
    }()
    
    // MARK: - Private Variables
    
    private var viewModel: BreathFocusViewModel?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configurePulseLayer()
//        configureProgressBar()
        
        configureUI()
        
        bindUI()
    }
    
    // MARK: - Initializer

    convenience init(viewModel: BreathFocusViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        breathShapeLayer.frame = breathView.bounds
        scalingShapeLayer.frame = breathView.bounds
        startBreathAnimation()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.makeBlurBackground()
               
//        view.backgroundColor = .gray
        
        view.addSubview(breathView)
        breathView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(breathView.snp.width)
            $0.centerY.equalTo(view.snp.centerY).multipliedBy(0.65)
        }
        breathView.layer.addSublayer(breathShapeLayer)
        breathView.layer.addSublayer(scalingShapeLayer)
        scalingShapeLayer.isHidden = true
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(breathView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
//            $0.center.equalTo(timeLabel)
            $0.center.equalTo(breathView.snp.center)
        }
        
        view.addSubview(minuteLabel)
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
    
    private func startBreath() {
        startButton.isHidden = true
        stopButton.isHidden = false
        timeLabel.isHidden = true
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
        
        let scaleUpAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleUpAnim.fromValue = CGPoint(x: 1, y: 1) // UIColor.gray.cgColor
        scaleUpAnim.toValue = CGPoint(x: 10.0, y: 10.0) // UIColor.green.cgColor
        scaleUpAnim.beginTime = 0.0
        scaleUpAnim.duration = 1.0
        scaleUpAnim.repeatCount = 1
        
        let colorAnim = CABasicAnimation(keyPath: "opacity")
        colorAnim.fromValue = 1.0//CGColor.init(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.5)
        colorAnim.toValue = 0.5//CGColor.init(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.2)
        colorAnim.duration = 1.0
        colorAnim.beginTime = 0.0
        colorAnim.repeatCount = 1
        
        let animations = CAAnimationGroup()
        animations.animations = [scaleUpAnim, colorAnim]
        animations.repeatCount = 1
        animations.duration = 1.0
        animations.beginTime = 0.0
        animations.isRemovedOnCompletion = true
        animations.fillMode = CAMediaTimingFillMode.forwards
//        breathShapeLayer.opacity =
//        breathShapeLayer.removeAllAnimations()
        breathShapeLayer.add(animations, forKey: nil)
        
//        self.breathShapeLayer.add(scaleUpAnim, forKey: "adf")
//        self.view.layer.backgroundColor = .init(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.5)
        // 진입 배경 애니메이션
        self.stopButton.layer.opacity = 0
        UIView.animate(withDuration: 1.0, delay: .zero, options: .curveEaseIn) {
            self.view.layer.backgroundColor = .init(red: 0.1, green: 1.0, blue: 0.1, alpha: 0.8)
        } completion: { flag in
            // 진입 완료 후
            print(#function, #line, flag)
            self.breathShapeLayer.isHidden = true
            UIView.animate(withDuration: 3.0) {
                self.scalingShapeLayer.isHidden = false
                self.view.layer.backgroundColor = .none
            }
            UIView.animate(withDuration: 1.0) {
                self.stopButton.layer.opacity = 1
            }
            self.startScalingAnimation()
        }
        
    }
    
    private func stopBreath() {
        
//        self.startButton.isHidden = false
//        self.stopButton.isHidden = true
        
        startButton.isHidden = false
        stopButton.isHidden = true
        timeLabel.isHidden = false
        timePickerView.isHidden = false
        minuteLabel.isHidden = false
        self.breathShapeLayer.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.view.layer.backgroundColor = .none
            self.scalingShapeLayer.removeAllAnimations()
            self.scalingShapeLayer.isHidden = true
        }
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
        
        viewModel?.focusState.bind(onNext: { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .running:
                self.startBreath()
            case .stop:
                self.stopBreath()
            }
        }).disposed(by: disposeBag)
    
//
//        continueButton.rx.tap
//            .bind { [weak self] in
//                guard let self = self else { return }
//                self.viewModel?.changeTimerState(to: .running(isContinue: true))
//            }
//            .disposed(by: disposeBag)
//
//        exitButton.rx.tap
//            .bind { [weak self] in
//                guard let self = self else { return }
//                self.viewModel?.changeTimerState(to: .ready)
//                self.viewModel?.resetClockTimer()
//                self.viewModel?.saveFocusRecord()
//            }
//            .disposed(by: disposeBag)
    }
    
    private func changeStateToPaused() {
        startButton.isHidden = true
//        pauseButton.isHidden = true
        timeLabel.isHidden = false
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
//        viewModel?.pauseClockTimer()
//        pauseTimerProgressAnimation()

//        UIView.animate(withDuration: 0.5) { [weak self] in
//            guard let self = self else { return }
//            self.continueButton.isHidden = false
//            self.exitButton.isHidden = false
//            self.continueButton.frame = CGRect(
//                x: self.continueButton.frame.minX * 0.45,
//                y: self.continueButton.frame.minY,
//                width: self.continueButton.frame.width,
//                height: self.continueButton.frame.height
//            )
//            self.exitButton.frame = CGRect(
//                x: self.exitButton.frame.minX * 1.55,
//                y: self.exitButton.frame.minY,
//                width: self.exitButton.frame.width,
//                height: self.exitButton.frame.height
//            )
//        }
    }
  
    private func startBreathAnimation() {
//        breathShapeLayer.add(BreathAnimation(frame: CGRect(origin: .zero,
//                                                           size: CGSize(width: 400, height: 400))),
//
//                             forKey: "breath")
        breathShapeLayer.add(BreathAnimation(frame: CGRect(origin: .zero,
                                                           size: CGSize(width: 400, height: 400))),
                             
                             forKey: "breath")
    }
    
    private func startScalingAnimation() {
        let animations = BreathAnimation(
            frame: breathView.bounds
        )
        
        let animScaleUp: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animScaleUp.fromValue = 0.5
        animScaleUp.toValue = 1
        animScaleUp.beginTime = animations.beginTime
        animScaleUp.duration = animations.duration / 3.0 * 2.0
        animScaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let animScaleDown: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animScaleDown.fromValue = 1
        animScaleDown.toValue = 0.5
        animScaleDown.beginTime = animations.beginTime + animations.duration / 3.0 * 2.0
        animScaleDown.duration = animations.duration / 3.0
        animScaleDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animations.isRemovedOnCompletion = true
        animations.repeatCount = Float(viewModel?.focusTime ?? 1)
        animations.animations?.append(animScaleUp)
        animations.animations?.append(animScaleDown)
        animations.delegate = self
        scalingShapeLayer.add(animations, forKey: "scaling")
    }
}

extension BreathFocusViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let focusTime = (viewModel?.focusTimeList[row] ?? 0) * 7
        viewModel?.setFocusTime(seconds: focusTime)
        self.timeLabel.text = "\(focusTime) breaths"
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
    func animationDidStart(_ anim: CAAnimation) {
        print(#function, #line)
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(#function, #line, flag, anim.description)
        self.viewModel?.resetClockTimer()
    }
}
 

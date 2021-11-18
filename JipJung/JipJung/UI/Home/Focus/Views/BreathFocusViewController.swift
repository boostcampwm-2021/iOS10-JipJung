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
        minuteLabel.textColor = .systemGray
        
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
    
    // MARK: - Private Variables
    
    private var viewModel: BreathFocusViewModel?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configurePulseLayer()
//        configureProgressBar()
        startBreathAnimation()
        
        configureUI()
        
        bindUI()
    }
    
    // MARK: - Initializer

    convenience init(viewModel: BreathFocusViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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
    }
    
    private func bindUI() {
//        viewModel?.timerState.bind(onNext: { [weak self] in
//                guard let self = self else { return }
//                switch $0 {
//                case .ready:
//                    self.changeStateToReady()
//                case .running(let isContinue):
//                    self.changeStateToRunning()
//                case .paused:
//                    self.changeStateToPaused()
//                }
//            })
//            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.changeTimerState(to: .running(isContinue: false))
            }
            .disposed(by: disposeBag)
        
//        pauseButton.rx.tap
//            .bind { [weak self] in
//                guard let self = self else { return }
//                self.viewModel?.changeTimerState(to: .paused)
//            }
//            .disposed(by: disposeBag)
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
        
//        viewModel?.clockTime
//            .bind(onNext: { [weak self] in
//                guard let self = self, $0 > 0,
//                      let focusTime = self.viewModel?.focusTime
//                else { return }
//                if $0 == focusTime {
//                    self.viewModel?.resetClockTimer()
//                    return
//                }
//                self.timeLabel.text = (focusTime - $0).digitalClockFormatted
//                self.startPulseAnimation(second: $0)
//            })
//            .disposed(by: disposeBag)
    }
    
    private func changeStateToReady() {
        timeLabel.text = viewModel?.focusTime.digitalClockFormatted
//        pauseButton.isHidden = true
        timeLabel.isHidden = true
        timePickerView.isHidden = false
        minuteLabel.isHidden = false
//        removeAllAnimations()
        
//        UIView.animate(withDuration: 0.5) { [weak self] in
//            guard let self = self else { return }
//            self.continueButton.frame = CGRect(
//                x: self.startButton.frame.minX,
//                y: self.continueButton.frame.minY,
//                width: self.continueButton.frame.width,
//                height: self.continueButton.frame.height
//            )
//            self.exitButton.frame = CGRect(
//                x: self.startButton.frame.minX,
//                y: self.exitButton.frame.minY,
//                width: self.exitButton.frame.width,
//                height: self.exitButton.frame.height
//            )
//        } completion: { _ in
//            self.continueButton.isHidden = true
//            self.exitButton.isHidden = true
//            self.startButton.isHidden = false
//        }
    }
    
//    private func changeStateToRunning() {
//        startButton.isHidden = true
//        timeLabel.isHidden = false
//        timePickerView.isHidden = true
//        minuteLabel.isHidden = true
//        viewModel?.startClockTimer()
//        switch viewModel?.timerState.value {
//        case .running(isContinue: true):
//            resumeTimerProgressAnimation()
//        case .running(isContinue: false):
//            startTimeProgressAnimation()
//        default:
//            break
//        }
//
//        UIView.animate(withDuration: 0.5) { [weak self] in
//            guard let self = self else { return }
//            self.continueButton.frame = CGRect(
//                x: self.startButton.frame.minX,
//                y: self.continueButton.frame.minY,
//                width: self.continueButton.frame.width,
//                height: self.continueButton.frame.height
//            )
//            self.exitButton.frame = CGRect(
//                x: self.startButton.frame.minX,
//                y: self.exitButton.frame.minY,
//                width: self.exitButton.frame.width,
//                height: self.exitButton.frame.height
//            )
//        } completion: { _ in
//            self.continueButton.isHidden = true
//            self.exitButton.isHidden = true
//            self.pauseButton.isHidden = false
//        }
//    }
    
    private func changeStateToPaused() {
        startButton.isHidden = true
//        pauseButton.isHidden = true
        timeLabel.isHidden = false
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
        viewModel?.pauseClockTimer()
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
    
//    private func createCircleShapeLayer(strokeColor: UIColor, lineWidth: CGFloat, startAngle: CGFloat = 0, endAngle: CGFloat = 2 * CGFloat.pi) -> CAShapeLayer {
//        let circleShapeLayer = CAShapeLayer()
//        let circlePath = UIBezierPath(arcCenter: .zero,
//                                      radius: 125,
//                                      startAngle: startAngle,
//                                      endAngle: endAngle,
//                                      clockwise: true)
//        circleShapeLayer.path = circlePath.cgPath
//        circleShapeLayer.strokeColor = strokeColor.cgColor
//        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
//        circleShapeLayer.lineWidth = lineWidth
//        circleShapeLayer.fillColor = UIColor.clear.cgColor
//        let centerX = view.center.x
//        let centerY = view.center.y * 0.7
//        circleShapeLayer.position = CGPoint(x: centerX, y: centerY)
//        return circleShapeLayer
//    }
    
//    private func startTimeProgressAnimation() {
//        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
//        animation.fromValue = 0
//        animation.toValue = 1
//        animation.duration = 100
//        animation.fillMode = .forwards
//        timeProgressLayer.add(animation, forKey: nil)
//        view.layer.addSublayer(timeProgressLayer)
//    }
  
    private func startBreathAnimation() {
        breathShapeLayer.add(BreathAnimation(frame: CGRect(origin: .zero,
                                                           size: CGSize(width: 400, height: 400))),
                             
                             forKey: "breath")
    }
    
//    private func startPulseAnimation(second: Int) {
//        self.pulseGroupLayer.sublayers?[second % 4].add(PulseAnimation(), forKey: "pulse")
//    }
//
//    private func pauseTimerProgressAnimation() {
//        timeProgressLayer.pauseLayer()
//    }
    
//    private func resumeTimerProgressAnimation() {
//        timeProgressLayer.resumeLayer()
//    }
//
//    private func removeAllAnimations() {
//        timeProgressLayer.removeAllAnimations()
//        timeProgressLayer.removeFromSuperlayer()
//        pulseGroupLayer.sublayers?.forEach({ $0.removeAllAnimations() })
//    }
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

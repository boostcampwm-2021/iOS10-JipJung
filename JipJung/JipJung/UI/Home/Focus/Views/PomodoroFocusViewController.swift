//
//  PomodoroFocusViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class PomodoroFocusViewController: FocusViewController {
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
        timeLabel.text = "01:00"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 35)
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    private lazy var relaxLabel: UILabel = {
        let relaxLabel = UILabel()
        relaxLabel.text = "Relax"
        relaxLabel.font = UIFont.boldSystemFont(ofSize: 15)
        relaxLabel.textColor = .white
        return relaxLabel
    }()
    
    private lazy var circleShapeLayer: CAShapeLayer = {
        let circleShapeLayer = createCircleShapeLayer(
            strokeColor: UIColor.systemGray,
            lineWidth: 3
        )
        return circleShapeLayer
    }()
    
    private lazy var timeProgressLayer: CAShapeLayer = {
        let timeProgressLayer = createCircleShapeLayer(
            strokeColor: .secondarySystemBackground,
            lineWidth: 3,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2
        )
        timeProgressLayer.fillColor = nil
        return timeProgressLayer
    }()
    private let pulseGroupLayer = CALayer()
    
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
    
    private lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        pauseButton.setTitleColor(UIColor.white, for: .normal)
        pauseButton.layer.cornerRadius = 25
        pauseButton.backgroundColor = .gray
        pauseButton.layer.borderColor = UIColor.white.cgColor
        pauseButton.layer.borderWidth = 2
        return pauseButton
    }()
    
    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.tintColor = .gray
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        continueButton.setTitleColor(UIColor.gray, for: .normal)
        continueButton.layer.cornerRadius = 25
        continueButton.backgroundColor = .white
        return continueButton
    }()
    
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        exitButton.setTitle("Exit", for: .normal)
        exitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        exitButton.setTitleColor(UIColor.white, for: .normal)
        exitButton.layer.cornerRadius = 25
        exitButton.backgroundColor = .gray
        exitButton.layer.borderColor = UIColor.white.cgColor
        exitButton.layer.borderWidth = 2
        return exitButton
    }()
    
    // MARK: - Private Variables
    
    var viewModel: PomodoroFocusViewModel?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePulseLayer()
        configureProgressBar()
        configureUI()
        
        bindUI()
    }
    
    // MARK: - Initializer

    convenience init(viewModel: PomodoroFocusViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.makeBlurBackground()
                
        view.layer.addSublayer(circleShapeLayer)
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(0.65)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.center.equalTo(timeLabel)
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
        
        view.addSubview(relaxLabel)
        relaxLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.15)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureProgressBar() {
        view.layer.addSublayer(timeProgressLayer)
    }
    
    private func configurePulseLayer() {
        view.layer.addSublayer(pulseGroupLayer)
        let pulseCount = 4
        for _ in 0..<pulseCount {
            let pulseLayer = createCircleShapeLayer(strokeColor: .secondarySystemBackground, lineWidth: 2)
            pulseGroupLayer.addSublayer(pulseLayer)
        }
    }
    
    private func bindUI() {
        viewModel?.timerState.bind(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .ready:
                    self.changeStateToReady()
                case .running(let isContinue):
                    self.changeStateToRunning()
                case .paused:
                    self.changeStateToPaused()
                }
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.changeTimerState(to: .running(isResume: false))
            }
            .disposed(by: disposeBag)
        
        pauseButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.changeTimerState(to: .paused)
            }
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.changeTimerState(to: .running(isResume: true))
            }
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if self.viewModel?.mode.value == .work {
                    self.alertNotification()
                }
                self.viewModel?.changeTimerState(to: .ready)
                self.viewModel?.resetClockTimer()
                self.viewModel?.saveFocusRecord()
                self.viewModel?.resetTotalFocusTime()
                self.viewModel?.changeToWorkMode()
            }
            .disposed(by: disposeBag)
        
        viewModel?.clockTime
            .bind(onNext: { [weak self] in
                guard let self = self, $0 > 0,
                      let focusTime = self.viewModel?.focusTime
                else { return }
                if $0 == focusTime {
                    self.alertNotification()
                    self.viewModel?.changeMode()
                    self.viewModel?.resetClockTimer()
                    self.changeStateToReady()
                    return
                }
                self.timeLabel.text = (focusTime - $0).digitalClockFormatted
                self.startPulseAnimation(second: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel?.mode
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .work:
                    self.relaxLabel.isHidden = true
                    self.view.backgroundColor = .clear
                    self.startButton.setTitle("Start", for: .normal)
                case .relax:
                    self.relaxLabel.isHidden = false
                    self.view.backgroundColor = UIColor(rgb: 0xA1D9BC,
                                                        alpha: 0.6)
                    self.startButton.setTitle("Relax", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func alertNotification() {
        guard let focusTime = self.viewModel?.focusTime,
              let clockTime = self.viewModel?.clockTime.value,
              let mode = self.viewModel?.mode.value
        else {
            return
        }
        let sadEmojis = ["🥶", "😣", "😞", "😟", "😕"]
        let happyEmojis = ["☺️", "😘", "😍", "🥳", "🤩"]
        let relaxEmojis = ["👍", "👏", "🤜", "🙌", "🙏"]
        switch mode {
        case .work:
            let minuteString = clockTime / 60 == 0 ? "" : "\(clockTime / 60)분 "
            let secondString = clockTime % 60 == 0 ? "" : "\(clockTime % 60)초 "
            let message = focusTime - clockTime > 0
            ? "완료시간 전에 종료되었어요." + (sadEmojis.randomElement() ?? "")
            : minuteString + secondString + "집중하셨어요!" + (happyEmojis.randomElement() ?? "")
            PushNotificationMananger.shared.presentFocusStopNotification(title: .focusFinish,
                                                                         body: message)
        case .relax:
            let message = "휴식시간이 끝났어요! 다시 집중해볼까요?" + (relaxEmojis.randomElement() ?? "")
            PushNotificationMananger.shared.presentFocusStopNotification(title: .relaxFinish,
                                                                         body: message)
        }
        FeedbackGenerator.shared.impactOccurred()
    }
    
    private func changeStateToReady() {
        timeLabel.text = viewModel?.focusTime.digitalClockFormatted
        pauseButton.isHidden = true
        timeLabel.isHidden = true
        timePickerView.isHidden = false
        minuteLabel.isHidden = false
        removeAllAnimations()
        
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
    
    private func changeStateToRunning() {
        startButton.isHidden = true
        timeLabel.isHidden = false
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
        viewModel?.startClockTimer()
        switch viewModel?.timerState.value {
        case .running(isResume: true):
            resumeTimerProgressAnimation()
        case .running(isResume: false):
            startTimeProgressAnimation()
        default:
            break
        }
        
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
    
    private func changeStateToPaused() {
        startButton.isHidden = true
        pauseButton.isHidden = true
        timeLabel.isHidden = false
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
        viewModel?.pauseClockTimer()
        pauseTimerProgressAnimation()

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
    
    private func createCircleShapeLayer(strokeColor: UIColor, lineWidth: CGFloat, startAngle: CGFloat = 0, endAngle: CGFloat = 2 * CGFloat.pi) -> CAShapeLayer {
        let circleShapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: .zero,
                                      radius: 125,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.strokeColor = strokeColor.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.lineWidth = lineWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        let centerX = view.center.x
        let centerY = view.center.y * 0.7
        circleShapeLayer.position = CGPoint(x: centerX, y: centerY)
        return circleShapeLayer
    }
    
    private func startTimeProgressAnimation() {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 100
        animation.fillMode = .forwards
        timeProgressLayer.add(animation, forKey: nil)
        view.layer.addSublayer(timeProgressLayer)
    }
    
    private func startPulseAnimation(second: Int) {
        self.pulseGroupLayer.sublayers?[second % 4].add(PulseAnimation(), forKey: "pulse")
    }
    
    private func pauseTimerProgressAnimation() {
        timeProgressLayer.pauseLayer()
    }
    
    private func resumeTimerProgressAnimation() {
        timeProgressLayer.resumeLayer()
    }
    
    private func removeAllAnimations() {
        timeProgressLayer.removeAllAnimations()
        timeProgressLayer.removeFromSuperlayer()
        pulseGroupLayer.sublayers?.forEach({ $0.removeAllAnimations() })
    }
}

extension PomodoroFocusViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let focusTime = (viewModel?.focusTimeList[row] ?? 0) * 60
        viewModel?.setFocusTime(seconds: focusTime)
        self.timeLabel.text = focusTime.digitalClockFormatted
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

extension PomodoroFocusViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.focusTimeList.count ?? 0
    }
}

//
//  PomodoroFocusViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift

final class PomodoroFocusViewController: FocusViewController {
    // MARK: - Subviews
    let timerView: UIView = {
        let length = FocusViewControllerSize.timerViewLength
        let size = CGSize(width: length, height: length)
        let timerView = UIView(frame: CGRect(origin: .zero, size: size))
        return timerView
    }()
    
    private lazy var timePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    private lazy var minuteLabel: UILabel = {
        let label = UILabel()
        label.text = "sec"
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "01:00"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        return label
    }()
    
    private lazy var relaxLabel: UILabel = {
        let label = UILabel()
        label.text = "Relax"
        label.font = .preferredFont(forTextStyle: .headline)
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
    
    private lazy var timeProgressLayer: CAShapeLayer = {
        let shapeLayer = createCircleShapeLayer(
            strokeColor: .white,
            lineWidth: 3,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2
        )
        shapeLayer.fillColor = nil
        return shapeLayer
    }()
    
    private let pulseGroupLayer = CALayer()
    
    private let startButton = FocusStartButton()
    private let pauseButton = FocusPauseButton()
    private let continueButton = FocusContinueButton()
    private let exitButton = FocusExitButton()
    
    // MARK: - Private Variables
    
    var viewModel: PomodoroFocusViewModel?
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimerUI()
        configureUI()
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
    // MARK: - Initializer

    convenience init(viewModel: PomodoroFocusViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Helpers
    
    private func configureTimerUI() {
        view.addSubview(timerView)
        configurePulseLayer()
        
        timerView.layer.addSublayer(circleShapeLayer)
        timerView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        timerView.addSubview(timePickerView)
        timePickerView.snp.makeConstraints {
            $0.center.equalTo(timeLabel)
        }
        
        timerView.addSubview(minuteLabel)
        minuteLabel.snp.makeConstraints {
            $0.centerY.equalTo(timePickerView)
            $0.centerX.equalTo(timePickerView.snp.centerX).offset(60)
        }
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
        
        view.addSubview(relaxLabel)
        relaxLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(1.2)
            $0.centerX.equalToSuperview()
        }
    }

    private func configurePulseLayer() {
        timerView.layer.addSublayer(pulseGroupLayer)
        let pulseCount = 4
        for _ in 0..<pulseCount {
            let pulseLayer = createCircleShapeLayer(strokeColor: .white, lineWidth: 2)
            pulseGroupLayer.addSublayer(pulseLayer)
        }
    }
    
    private func bindUI() {
        viewModel?.timerState.bind(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .ready:
                    self.presentReady()
                case .running(let isResume):
                    self.viewModel?.startClockTimer()
                    if isResume {
                        self.presentResume()
                    } else {
                        self.presentStart(with: self.viewModel?.focusTime ?? 0)
                    }
                case .paused:
                    self.viewModel?.pauseClockTimer()
                    self.presentPaused()
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
                    self.viewModel?.alertNotification()
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
                    self.viewModel?.alertNotification()
                    self.viewModel?.changeMode()
                    self.viewModel?.resetClockTimer()
                    self.presentReady()
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
    
    private func presentReady() {
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
    
    private func presentStart(with duration: Int) {
        presentRunning()
        resumeTimerProgressAnimation()
        startTimeProgressAnimation(with: duration)
    }
    
    private func presentResume() {
        presentRunning()
        resumeTimerProgressAnimation()
    }
    
    private func presentRunning() {
        startButton.isHidden = true
        timeLabel.isHidden = false
        timePickerView.isHidden = true
        minuteLabel.isHidden = true
        
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
        timeLabel.isHidden = false
        timePickerView.isHidden = true
        minuteLabel.isHidden = true

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
    
    private func createCircleShapeLayer(strokeColor: UIColor,
                                        lineWidth: CGFloat,
                                        startAngle: CGFloat = 0,
                                        endAngle: CGFloat = 2 * CGFloat.pi) -> CAShapeLayer {
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
    
    private func startTimeProgressAnimation(with duration: Int) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = .forwards
        timeProgressLayer.add(animation, forKey: nil)
        timerView.layer.addSublayer(timeProgressLayer)
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
        let pickerValue = (viewModel?.focusTimeList[row] ?? 0)
        viewModel?.setFocusTime(value: pickerValue)
        self.timeLabel.text = (viewModel?.focusTime ?? 0).digitalClockFormatted
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // NOTE: 시연 용이성을 위해 변경
        guard let viewModel = viewModel else {
            return UILabel()
        }
        let pickerValue = viewModel.focusTimeList[row]
        let text = "\(pickerValue * viewModel.timeUnit)"
        timePickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
        var pickerLabel: UILabel = UILabel()
        pickerLabel = UILabel()
        pickerLabel.text = "\(text)"
        pickerLabel.textColor = UIColor.white
        pickerLabel.font = .preferredFont(forTextStyle: .largeTitle)
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

//
//  InfinityFocusViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class InfinityFocusViewController: FocusViewController {
    // MARK: - Subviews
    private lazy var timerView: UIView = {
        let timerView = UIView(frame: UIScreen.main.bounds)
        timerView.isUserInteractionEnabled = false
        return timerView
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "00:00"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 35)
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    private lazy var circleShapeLayer: CAShapeLayer = {
        let circleShapeLayer = createCircleShapeLayer(
            strokeColor: UIColor.systemGray,
            lineWidth: 3
        )
        return circleShapeLayer
    }()
    
    private lazy var cometAnimationLayer: CALayer = {
        let rotateAnimationLayer = createCometCircleShapeLayer(strokeColor: .white, lineWidth: 3)
        return rotateAnimationLayer
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
    
    private var viewModel: InfinityFocusViewModel?
    private var disposeBag: DisposeBag = DisposeBag()
    
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
            self?.timerView.center = CGPoint(x: viewCenter.x, y: viewCenter.y * 0.8)
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
        } completion: { [weak self] in
            if $0 {
                self?.cometAnimationLayer.add(CycleAnimation(), forKey: nil)
            }
        }
    }
    
    // MARK: - Initializer

    convenience init(viewModel: InfinityFocusViewModel) {
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
        configureCometLayer()
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
    
    private func configurePulseLayer() {
        timerView.layer.addSublayer(pulseGroupLayer)
        let pulseCount = 4
        for _ in 0..<pulseCount {
            let pulseLayer = createCircleShapeLayer(strokeColor: .secondarySystemBackground, lineWidth: 2)
            pulseGroupLayer.addSublayer(pulseLayer)
        }
    }
    
    private func configureCometLayer() {
        timerView.layer.addSublayer(cometAnimationLayer)
    }
    
    func bindUI() {
        startButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.startClockTimer()
            }
            .disposed(by: disposeBag)
        
        pauseButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.pauseClockTimer()
            }
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.startClockTimer()
            }
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.viewModel?.resetClockTimer()
                self.viewModel?.saveFocusRecord()
            }
            .disposed(by: disposeBag)
        
        viewModel?.clockTime
            .bind(onNext: { [weak self] in
                guard let self = self, $0 > 0 else { return }
                self.timeLabel.text = $0.digitalClockFormatted
                self.startPulse(second: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel?.timerState.bind(onNext: { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .ready:
                self.changeStateToReady()
                self.stopTimer()
            case .running(let isContinue):
                self.changeStateToRunning()
                isContinue ? self.resumeTimerProgressBar() : self.startTimer()
            case .paused:
                self.changeStateToPaused()
                self.pauseTimerProgressBar()
            }
        })
    }
    
    private func changeStateToReady() {
        pauseButton.isHidden = true
        timeLabel.text = 0.digitalClockFormatted
        
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
        
        viewModel?.startWaveAnimationTimer()
    }
    
    private func changeStateToPaused() {
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
        circleShapeLayer.position = timerView.center
        return circleShapeLayer
    }
    
    private func startTimer() {
    }
    
    private func startPulse(second: Int) {
        self.pulseGroupLayer.sublayers?[second % 4].add(PulseAnimation(), forKey: "pulse")
    }
    
    private func pauseTimerProgressBar() {
    }
    
    private func resumeTimerProgressBar() {
    }
    
    private func stopTimer() {
        pulseGroupLayer.sublayers?.forEach({ $0.removeAllAnimations() })
    }
    
    private func createCometCircleShapeLayer(strokeColor: UIColor, lineWidth: CGFloat) -> CALayer {
        let circleShapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: .zero,
                                      radius: 125,
                                      startAngle: 0,
                                      endAngle: 2 * CGFloat.pi,
                                      clockwise: true)
        
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.strokeColor = UIColor.red.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.lineWidth = lineWidth
        circleShapeLayer.fillColor = UIColor.clear.cgColor
        circleShapeLayer.position = view.center
        
        let gradient = CAGradientLayer()
        gradient.frame = timerView.bounds
        gradient.position = view.center
        gradient.colors = [UIColor.systemGray.cgColor, strokeColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1)
        gradient.locations = [0.8, 1]
        gradient.type = .conic
        gradient.mask = circleShapeLayer
        return gradient
    }
}

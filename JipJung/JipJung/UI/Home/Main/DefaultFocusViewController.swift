//
//  DefaultFocusViewController.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class DefaultFocusViewController: UIViewController {
    // MARK: - Subviews
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "00:00"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 35)
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    private lazy var circleShapeLayer: CAShapeLayer = {
        let circleShapeLayer = createCircleShapeLayer(strokeColor: UIColor.systemGray,
                                                      lineWidth: 3)
        return circleShapeLayer
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
    
    private var viewModel: DefaultFocusViewModel?
    private var disposeBag: DisposeBag = DisposeBag()
    private var state = BehaviorRelay<FocusState>(value: .ready)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
    }
    
    // MARK: - Initializer

    convenience init(viewModel: DefaultFocusViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .gray
                
        view.layer.addSublayer(circleShapeLayer)
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(0.65)
            $0.centerX.equalToSuperview()
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
    }
    
    func bindUI() {
        state.bind { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .ready:
                self.changeStateToReady()
            case .running:
                self.changeStateToRunning()
            case .paused:
                self.changeStateToPaused()
            }
        }
        .disposed(by: disposeBag)
        
        startButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.state.accept(.running)
                self.viewModel?.startClockTimer()
            }
            .disposed(by: disposeBag)
        
        pauseButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.state.accept(.paused)
                self.viewModel?.pauseClockTimer()
            }
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.state.accept(.running)
                self.viewModel?.startClockTimer()
            }
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.state.accept(.ready)
                self.viewModel?.resetClockTimer()
            }
            .disposed(by: disposeBag)
        
        viewModel?.clockTime
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.timeLabel.text = $0.digitalClockFormatted
            })
            .disposed(by: disposeBag)
        
        viewModel?.waveAnimationTime
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if $0 > 0 {
                    self.animateWave()
                }
                if let sublayers = self.view.layer.sublayers,
                   sublayers.count > 15 {
                    self.view.layer.sublayers?.removeSubrange(10...sublayers.count-3)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func changeStateToReady() {
        pauseButton.isHidden = true
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.continueButton.frame = CGRect(x: self.startButton.frame.minX,
                                               y: self.continueButton.frame.minY,
                                               width: self.continueButton.frame.width,
                                               height: self.continueButton.frame.height)
            self.exitButton.frame = CGRect(x: self.startButton.frame.minX,
                                           y: self.exitButton.frame.minY,
                                           width: self.exitButton.frame.width,
                                           height: self.exitButton.frame.height)
        } completion: { _ in
            self.continueButton.isHidden = true
            self.exitButton.isHidden = true
            self.startButton.isHidden = false
        }
    }
    
    func changeStateToRunning() {
        startButton.isHidden = true
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.continueButton.frame = CGRect(x: self.startButton.frame.minX,
                                               y: self.continueButton.frame.minY,
                                               width: self.continueButton.frame.width,
                                               height: self.continueButton.frame.height)
            self.exitButton.frame = CGRect(x: self.startButton.frame.minX,
                                           y: self.exitButton.frame.minY,
                                           width: self.exitButton.frame.width,
                                           height: self.exitButton.frame.height)
        } completion: { _ in
            self.continueButton.isHidden = true
            self.exitButton.isHidden = true
            self.pauseButton.isHidden = false
        }
        
        viewModel?.startWaveAnimationTimer()
    }
    
    func changeStateToPaused() {
        startButton.isHidden = true
        pauseButton.isHidden = true

        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.continueButton.isHidden = false
            self.exitButton.isHidden = false
            self.continueButton.frame = CGRect(x: self.continueButton.frame.minX * 0.45,
                                               y: self.continueButton.frame.minY,
                                               width: self.continueButton.frame.width,
                                               height: self.continueButton.frame.height)
            self.exitButton.frame = CGRect(x: self.exitButton.frame.minX * 1.55,
                                           y: self.exitButton.frame.minY,
                                           width: self.exitButton.frame.width,
                                           height: self.exitButton.frame.height)
        }
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let circleShapeLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: .zero,
                                      radius: 125,
                                      startAngle: -CGFloat.pi / 2,
                                      endAngle: 3 * CGFloat.pi / 2 ,
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

    func animateWave() {
        let waveAnimationLayer = createCircleShapeLayer(strokeColor: UIColor.white,
                                                        lineWidth: 1)
        view.layer.addSublayer(waveAnimationLayer)
        
        let waveAnimation = CABasicAnimation(keyPath: "transform.scale")
        waveAnimation.toValue = 1.5
        
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        
        CATransaction.begin()
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [waveAnimation, fadeOutAnimation]
        animationGroup.duration = 3
        animationGroup.repeatCount = 1
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        waveAnimationLayer.add(animationGroup, forKey: "wave")
        CATransaction.commit()
    }
}
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

enum ButtonSize {
    static let startButton = CGSize(width: 115, height: 50)
    static let pauseButton = CGSize(width: 100, height: 50)
    static let continueButton = CGSize(width: 115, height: 50)
    static let exitButton = CGSize(width: 115, height: 50)
}

enum InfinityFocusState {
    case ready
    case running
    case paused
}

class InfinityFocusViewController: UIViewController {
    // MARK: - Subviews
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "00:00"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 35)
        timeLabel.textColor = .white
        return timeLabel
    }()
    
    private lazy var circleShapeLayer: CAShapeLayer = {
        let circleShapeLayer = CAShapeLayer()
        let centerX = view.center.x
        let centerY = view.center.y * 0.7
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                      radius: 125,
                                      startAngle: 0,
                                      endAngle: 2 * CGFloat.pi,
                                      clockwise: true)
        circleShapeLayer.path = circlePath.cgPath
        circleShapeLayer.strokeColor = UIColor.systemGray.cgColor
        circleShapeLayer.lineCap = CAShapeLayerLineCap.round
        circleShapeLayer.lineWidth = 3
        circleShapeLayer.fillColor = UIColor.clear.cgColor
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
    
    private var disposeBag: DisposeBag = DisposeBag()
    private var state = BehaviorRelay<InfinityFocusState>(value: .ready)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
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
            $0.width.equalTo(ButtonSize.startButton.width)
            $0.height.equalTo(ButtonSize.startButton.height)
        }

        view.addSubview(pauseButton)
        pauseButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ButtonSize.pauseButton.width)
            $0.height.equalTo(ButtonSize.pauseButton.height)
        }

        view.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ButtonSize.continueButton.width)
            $0.height.equalTo(ButtonSize.continueButton.height)
        }

        view.addSubview(exitButton)
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).multipliedBy(1.4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ButtonSize.exitButton.width)
            $0.height.equalTo(ButtonSize.exitButton.height)
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
                self?.state.accept(.running)
            }
            .disposed(by: disposeBag)
        
        pauseButton.rx.tap
            .bind { [weak self] in
                self?.state.accept(.paused)
            }
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind { [weak self] in
                self?.state.accept(.running)
            }
            .disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind { [weak self] in
                self?.state.accept(.ready)
            }
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
}

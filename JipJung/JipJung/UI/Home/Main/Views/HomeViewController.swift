//
//  HomeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//
import AVKit
import UIKit

import RxCocoa
import RxSwift
import SnapKit

class HomeViewController: UIViewController {
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private lazy var mainScrollContentsView = UIView()
    private lazy var mediaControlBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.makeBlurBackground()
        return view
    }()
    private lazy var carouselView = CarouselView()
    private lazy var topView = UIView()
    private lazy var bottomView = UIView()
    private lazy var touchTransferView = TouchTransferView()
    
    private let viewModel: HomeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private var isAttached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
        
        viewModel.viewControllerLoaded()
    }
    
    private func configureUI() {
        view.backgroundColor = .lightGray
        
        configureMainScrollView()
        configureCarouselView()
        configureMediaControlBackgroundView()
        configureTopView()
        configureBottomView()
        configureTouchTransferView()
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        mainScrollView.backgroundColor = .clear
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainScrollView.addSubview(mainScrollContentsView)
        mainScrollContentsView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
    
    private func configureCarouselView() {
        carouselView.backgroundColor = .clear
        mainScrollContentsView.addSubview(carouselView)
        carouselView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    private func configureMediaControlBackgroundView() {
        mainScrollContentsView.addSubview(mediaControlBackgroundView)
        mediaControlBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }

    private lazy var maximButton: UIButton = {
        let maximButton = UIButton()
        maximButton.setTitle("명언", for: .normal)
        maximButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        maximButton.backgroundColor = .red
        return maximButton
    }()
    
    private func configureTopView() {
        mainScrollContentsView.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(HomeMainViewSize.topViewHeight)
        }
        
        let helloLabel: UILabel = {
            let label = UILabel()
            label.text = "Hi, friend"
            label.textColor = .white
            label.font = .preferredFont(forTextStyle: .title3)
            return label
        }()
        
        topView.addSubview(helloLabel)
        helloLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(topView.snp.centerY).offset(-4)
        }
        
        let nowStateLabel: UILabel = {
            let label = UILabel()
            label.text = "Good Day"
            label.textColor = .white
            label.font = .preferredFont(forTextStyle: .title1)
            return label
        }()
        
        topView.addSubview(nowStateLabel)
        nowStateLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        let modeSwitch: UIButton = {
            let button = UIButton()
            let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
            button.setImage(
                UIImage(systemName: "repeat.circle.fill", withConfiguration: configuration),
                for: .normal
            )
            button.tintColor = .white
            return button
        }()
        
        modeSwitch.rx.tap
            .bind { [weak self] in
                self?.viewModel.modeSwitchTouched()
            }
            .disposed(by: disposeBag)
        
        topView.addSubview(modeSwitch)
        modeSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(40)
        }
    }
    
    private func configureBottomView() {
        mainScrollContentsView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(
                HomeMainViewSize.mediaControlViewHeight + HomeMainViewSize.topViewHeight
            )
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(HomeMainViewSize.bottomViewHeight)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(bottomViewDragged(_:)))
        panGesture.minimumNumberOfTouches = 1
        bottomView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        let focusButtonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        bottomView.addSubview(focusButtonStackView)
        focusButtonStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(90)
        }
        
        view.isUserInteractionEnabled = true
        FocusMode.allCases.forEach { focusMode in
            let focusView = FocusButton()
            focusView.set(mode: focusMode)
            focusView.buttonClickListener = { [weak self] in
                let focusViewController = focusMode.getFocusViewController()
                focusViewController.modalPresentationStyle = .custom
                focusViewController.transitioningDelegate = self
                self?.present(focusViewController, animated: true)
            }
            focusButtonStackView.addArrangedSubview(focusView)
            focusView.snp.makeConstraints {
                $0.width.equalTo(HomeMainViewSize.focusButtonSize.width)
                $0.height.equalTo(HomeMainViewSize.focusButtonSize.height)
            }
        }
        
        bottomView.addSubview(maximButton)
        maximButton.snp.makeConstraints {
            $0.width.equalTo(focusButtonStackView.snp.width)
            $0.top.equalTo(focusButtonStackView.snp.bottom).offset(16)
            $0.leading.equalTo(focusButtonStackView.snp.leading)
            $0.height.equalTo(50)
        }
        maximButton.rx.tap.bind {
            let maximViewController = MaximViewController()
            maximViewController.modalPresentationStyle = .overCurrentContext
            self.present(maximViewController, animated: true)
        }
    }
    
    private func configureTouchTransferView() {
        touchTransferView.transferView = carouselView
        view.addSubview(touchTransferView)
        touchTransferView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(HomeMainViewSize.topViewHeight + UIApplication.statusBarHeight)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(HomeMainViewSize.mediaControlViewHeight)
        }
    }
    
    private func bindUI() {
        bindUIWithViewModel()
    }
    
    private func bindUIWithViewModel() {
        viewModel.currentModeList
            .distinctUntilChanged()
            .bind { [weak self] mediaList in
                self?.carouselView.replaceContents(contents: mediaList)
            }
            .disposed(by: disposeBag)
    }
    
    private func mediaPlayButtonTouched(audioFileName: String) -> Single<Bool> {
        return viewModel.mediaPlayButtonTouched(audioFileName)
    }
    
    @objc private func bottomViewDragged(_ sender: UIPanGestureRecognizer) {
        if sender.state != .ended { return }
        
        let moveY = sender.translation(in: sender.view).y
        
        if (self.isAttached && moveY > 0) || (!self.isAttached && moveY < 0) {
            self.isAttached = true
            self.mainScrollView.setContentOffset(
                CGPoint(x: 0, y: HomeMainViewSize.mediaControlViewHeight - UIApplication.statusBarHeight),
                animated: true
            )
        } else {
            if self.isAttached { return }
            
            if moveY > 0 {
                self.isAttached = false
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: -UIApplication.statusBarHeight), animated: true)
            }
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentContentsOffsetY = scrollView.contentOffset.y
        let currentTopBottomYGap = HomeMainViewSize.mediaControlViewHeight - (currentContentsOffsetY + UIApplication.statusBarHeight)

        if currentTopBottomYGap <= 0 {
            isAttached = true
            topView.snp.updateConstraints {
                $0.top.equalTo(view.snp.topMargin).offset(currentTopBottomYGap)
            }
        } else {
            isAttached = false
            topView.snp.updateConstraints {
                $0.top.equalTo(view.snp.topMargin)
            }
            touchTransferView.snp.updateConstraints {
                $0.height.equalTo(max(0, currentTopBottomYGap))
            }
        }

        let currentHeight = currentTopBottomYGap
        let totalHeight = HomeMainViewSize.mediaControlViewHeight
        mediaControlBackgroundView.alpha = 1 - currentHeight / totalHeight
    }
}

extension HomeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlowPresent(duration: 0.5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlowPresent(duration: 0.5, animationType: .dismiss)
    }
}

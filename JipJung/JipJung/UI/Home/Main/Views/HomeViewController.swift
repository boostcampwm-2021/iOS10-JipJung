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
    private var mediaCollectionView: UICollectionView?
    private lazy var mediaControlBackgroundView: UIView = {
        let view = UIView()
        view.makeBlurBackground()
        return view
    }()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    private lazy var topView = UIView()
    private lazy var modeSwitch: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))
        button.setImage(
            UIImage(systemName: "repeat.circle.fill", withConfiguration: configuration),
            for: .normal
        )
        button.tintColor = .white
        return button
    }()
    private lazy var bottomView = UIView()
    
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
        configureMediaCollectionView()
        configureMediaControlBackgroundView()
        configureTopView()
        configureBottomView()
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        
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
    
    private func configureMediaCollectionView() {
        mediaCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeMediaCollectionLayout()
        )
        
        guard let mediaCollectionView = mediaCollectionView else { return }
        
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.register(
            MediaCollectionViewCell.self,
            forCellWithReuseIdentifier: MediaCollectionViewCell.identifier
        )
        mediaCollectionView.addGestureRecognizer(UIPanGestureRecognizer(target: nil, action: nil))
        mediaCollectionView.contentInsetAdjustmentBehavior = .never
        
        mainScrollContentsView.addSubview(mediaCollectionView)
        mediaCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    private func makeMediaCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        // Reference: https://developer.apple.com/documentation/uikit/nscollectionlayoutsectionvisibleitemsinvalidationhandler
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, environment in
            guard let self = self,
                  let mediaCollectionView = self.mediaCollectionView
            else {
                return
            }
            
            let cellCount = mediaCollectionView.numberOfItems(inSection: 0)
            let pageOffset = offset.x / self.view.frame.width
            let nearestPage = round(pageOffset)
            let startPage = 0
            let firstContentsPage = 1
            let lastContentsPage = cellCount - 2
            let endPage = cellCount - 1
            
            if cellCount == 1 {
                self.pageControl.currentPage = 0
            } else {
                
                var currentContentsPage = Int(nearestPage)
                if currentContentsPage == startPage {
                    currentContentsPage = lastContentsPage
                } else if currentContentsPage == endPage {
                    currentContentsPage = firstContentsPage
                }
                let visiblePageindex = currentContentsPage - 1
                /*
                 nearestPage -> currentContentsPage -> pageControl CurrentPage
                 0 -> 3 -> 2
                 1 -> 1 -> 0
                 2 -> 2 -> 1
                 3 -> 3 -> 2
                 4 -> 1 -> 0
                 */
                self.pageControl.currentPage = visiblePageindex
            }
            
            // Reference: iOS05-Escaper의 3주차 데모 발표 QnA
            items.forEach { item in
                guard let cell = mediaCollectionView.cellForItem(at: item.indexPath)
                else { return }
                
                if pageOffset == nearestPage {
                    cell.layer.masksToBounds = false
                    cell.layer.cornerRadius = 0
                    cell.transform = CGAffineTransform.identity
                    
                    if Int(pageOffset) == startPage {
                        mediaCollectionView.scrollToItem(at: [0, lastContentsPage], at: .right, animated: false)
                    } else if Int(pageOffset) == endPage {
                        mediaCollectionView.scrollToItem(at: [0, firstContentsPage], at: .left, animated: false)
                    }
                    
                } else {
                    let distance = abs(nearestPage - pageOffset)
                    let distanceRatio = min(0.1, distance)
                    
                    cell.layer.masksToBounds = true
                    cell.layer.cornerRadius = 40 * (distanceRatio * 10)
                    cell.transform = CGAffineTransform(scaleX: 1 - distanceRatio, y: 1 - distanceRatio)
                }
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureMediaControlBackgroundView() {
        mainScrollContentsView.addSubview(mediaControlBackgroundView)
        mediaControlBackgroundView.isUserInteractionEnabled = false
        
        mediaControlBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        mediaControlBackgroundView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-UIScreen.deviceScreenSize.height * 0.3)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    private lazy var maximButton: UIButton = {
        let maximButton = UIButton()
        maximButton.setTitle("명언", for: .normal)
        maximButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        maximButton.makeBlurBackground()
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
        panGesture.delegate = self
        bottomView.addGestureRecognizer(panGesture)
        
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
    
    private func bindUI() {
        bindUIWithMediaCollectionView()
        bindUIWithViewModel()
    }
    
    private func bindUIWithMediaCollectionView() {
        guard let mediaCollectionView = mediaCollectionView else { return }
        
        Observable
            .zip(
                mediaCollectionView.rx.itemSelected,
                mediaCollectionView.rx.modelSelected(Media.self)
            )
            .bind { [weak self] indexPath, model in
                guard let self = self,
                      let cell = mediaCollectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
                else {
                    return
                }
                
                self.mediaPlayButtonTouched(audioFileName: model.audioFileName)
                    .subscribe { state in
                        state ? cell.playVideo() : cell.pauseVideo()
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUIWithViewModel() {
        guard let mediaCollectionView = mediaCollectionView
        else {
            return
        }
        
        viewModel.currentModeList
            .distinctUntilChanged()
            .bind(
                to: mediaCollectionView.rx.items(cellIdentifier: MediaCollectionViewCell.identifier)
            ) { [weak self] _, element, cell in
                guard let self = self,
                      let cell = cell as? MediaCollectionViewCell
                else {
                    return
                }
                self.viewModel.mediaCollectionCellLoaded(element.videoFileName)
                    .subscribe { url in
                        cell.setVideo(videoURL: url)
                    }.disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.currentModeList
            .distinctUntilChanged()
            .map { $0.count }
            .filter { $0 != 0 }
            .bind { [weak self] count in
                self?.view.layoutIfNeeded()
                let contentsPages = count == 1 ? 1 : count - 2
                self?.pageControl.numberOfPages = contentsPages
                self?.mediaCollectionView?.scrollToItem(at: [0, count/2], at: .left, animated: false)
                self?.pageControl.currentPage = contentsPages / 2
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
        }
        
        mediaControlBackgroundView.subviews.forEach {
            if $0 == pageControl {
                $0.alpha = currentTopBottomYGap / HomeMainViewSize.mediaControlViewHeight
            } else {
                $0.alpha = 1 - currentTopBottomYGap / HomeMainViewSize.mediaControlViewHeight
            }
        }
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

//
//  HomeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//
import AVKit
import UIKit

import RxSwift
import SnapKit

class HomeViewController: UIViewController {
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let mainScrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    private var mediaCollectionView: UICollectionView?
    private let mediaControlBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .red.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = 0
        return pageControl
    }()
    private let topView = UIView()
    private let bottomView = UIView()
    
    private let viewModel = HomeViewModel()
    
    private var videoPlayer: AVPlayer?
    private var audioPlayer: AVAudioPlayer?
    private var isAttached = false
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()

        viewModel.viewControllerLoaded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureMainScrollView()
        configureMediaCollectionView()
        configureMediaControlBackgroundView()
        configureTopView()
        configureBottomView()
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        
        mainScrollView.backgroundColor = .clear
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainScrollContentsView.backgroundColor = .clear
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
        mediaCollectionView?.backgroundColor = .gray.withAlphaComponent(0.3)
        mediaCollectionView?.delegate = self
        mediaCollectionView?.register(
            MediaCollectionViewCell.self,
            forCellWithReuseIdentifier: MediaCollectionViewCell.identifier
        )
        mediaCollectionView?.addGestureRecognizer(UIPanGestureRecognizer(target: nil, action: nil))
        mediaCollectionView?.contentInsetAdjustmentBehavior = .never
        mediaCollectionView?.isPagingEnabled = true
        
        guard let mediaCollectionView = mediaCollectionView else { return }
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
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureMediaControlBackgroundView() {
        mainScrollContentsView.addSubview(mediaControlBackgroundView)
        mediaControlBackgroundView.isUserInteractionEnabled = false
        
        mediaControlBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        let playImageButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "play"), for: .normal)
            button.backgroundColor = .gray.withAlphaComponent(0.5)
            return button
        }()
        mediaControlBackgroundView.addSubview(playImageButton)
        playImageButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        mediaControlBackgroundView.addSubview(pageControl)
        pageControl.backgroundColor = .gray.withAlphaComponent(1)
        pageControl.snp.makeConstraints {
            $0.top.equalTo(playImageButton.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
    }
    
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
            button.addTarget(
                self,
                action: #selector(modeSwitchTouched(_:)),
                for: .touchUpInside
            )
            button.backgroundColor = .gray.withAlphaComponent(0.5)
            return button
        }()
        
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
                focusViewController.delegate = self
                focusViewController.modalPresentationStyle = .custom
                focusViewController.transitioningDelegate = self
                self?.present(focusViewController, animated: true, completion: nil)
            }
            focusButtonStackView.addArrangedSubview(focusView)
            focusView.snp.makeConstraints {
                $0.width.equalTo(HomeMainViewSize.focusButtonSize.width)
                $0.height.equalTo(HomeMainViewSize.focusButtonSize.height)
            }
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
                guard let result = self?.mediaPlayButtonTouched(audioFileName: model.audioFileName),
                      let cell = mediaCollectionView.cellForItem(at: indexPath) as? MediaCollectionViewCell
                else {
                    return
                }
                
                result ? cell.playVideo() : cell.pauseVideo()
            }
            .disposed(by: bag)
    }
    
    private func bindUIWithViewModel() {
        guard let mediaCollectionView = mediaCollectionView
        else {
            return
        }
        
        viewModel.isPlaying.bind(
            onNext: { [weak self] state in
                if state {
                    self?.audioPlayer?.play()
                    self?.videoPlayer?.play()
                } else {
                    self?.audioPlayer?.pause()
                    self?.videoPlayer?.pause()
                }
            }
        ).disposed(by: bag)
        
        viewModel.currentModeList.bind(
            to: mediaCollectionView.rx.items(cellIdentifier: MediaCollectionViewCell.identifier)
        ) { [weak self] item, element, cell in
            guard let self = self,
                  let cell = cell as? MediaCollectionViewCell
            else {
                return
            }
            self.viewModel.mediaCollectionCellLoaded(element.videoFileName)
                .subscribe { url in
                    cell.setVideo(videoURL: url)
                }.disposed(by: self.bag)
        }
        .disposed(by: bag)
        
        viewModel.currentModeList
            .distinctUntilChanged()
            .map { $0.count }
            .filter { $0 != 0 }
            .bind { [weak self] count in
                self?.pageControl.currentPage = 0
                self?.pageControl.numberOfPages = count
            }
            .disposed(by: bag)
    }
    
    private func mediaPlayButtonTouched(audioFileName: String) -> Bool {
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
    @objc private func modeSwitchTouched(_ sender: UIButton) {
        viewModel.modeSwitchTouched()
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
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == mainScrollView {
            return
        }
        let page = Int(targetContentOffset.pointee.x / view.frame.width)
        self.pageControl.currentPage = page
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

extension HomeViewController: FocusViewControllerDelegate {
    func closeButtonDidClicked(_ sender: UIViewController) {
        sender.dismiss(animated: true, completion: nil)
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

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
    private var mediaCollectionView: UICollectionView?
    private let mediaBackgroundView = UIView()
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let mainScrollContentsView: UIView = {
        let view = UIView()
        return view
    }()
    private let topView = UIView()
    private let mediaControllView = UIView()
    private let bottomView = UIView()
    
    private let topViewHeight = SystemConstants.deviceScreenSize.width / 3
    private let mediaControlViewHeight = SystemConstants.deviceScreenSize.height / 2
    private let bottomViewHeight = SystemConstants.deviceScreenSize.height
    private let focusButtonSize: (width: CGFloat, height: CGFloat) = (60, 90)
    
    private var viewModel: HomeViewModel?
    private var videoPlayer: AVPlayer?
    private var audioPlayer: AVAudioPlayer?
    private var isAttached = false
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureUI()
        bindUI()
        
        viewModel?.viewControllerLoaded()
    }
    
    private func configureViewModel() {
        viewModel = HomeViewModel(soundListUseCase: SoundListUseCase())
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureMainScrollView()
        configureMediaCollectionView()
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
        guard let mediaCollectionView = mediaCollectionView else { return }
        
        mainScrollContentsView.addSubview(mediaCollectionView)
        mediaCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        mediaCollectionView.register(
            MediaCollectionViewCell.self,
            forCellWithReuseIdentifier: MediaCollectionViewCell.identifier
        )
        mediaCollectionView.contentInsetAdjustmentBehavior = .never
        mediaCollectionView.bounces = false
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
    
    private func configureTopView() {
        mainScrollContentsView.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(topViewHeight)
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
            $0.top.equalToSuperview().offset(mediaControlViewHeight + topViewHeight)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(bottomViewHeight)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(bottomViewDragged(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
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
        
        FocusMode.allCases.forEach { mode in
            let focusView = FocusButton()
            focusView.set(mode: mode)
            focusView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(focusButtonTouched(_:)))
            )
            focusButtonStackView.addArrangedSubview(focusView)
            focusView.snp.makeConstraints {
                $0.width.equalTo(focusButtonSize.width)
                $0.height.equalTo(focusButtonSize.height)
            }
        }
    }
    
    private func bindUI() {
        bindUIInController()
        bindUIWithViewModel()
    }
    
    private func bindUIInController() {
        guard let mediaCollectionView = mediaCollectionView else { return }
        
        mediaCollectionView
            .rx
            .modelSelected(String.self)
            .subscribe(onNext: { item in
                print(item)
            })
            .disposed(by: bag)
    }
    
    private func bindUIWithViewModel() {
        guard let viewModel = viewModel,
              let mediaCollectionView = mediaCollectionView
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
        ) { item, element, cell in
            guard let cell = cell as? MediaCollectionViewCell,
                  let videoURL = Bundle.main.url(forResource: element, withExtension: "mp4")
            else {
                return
            }
            cell.setVideo(videoURL: videoURL) // element.videoURL
        }
        .disposed(by: bag)
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    @objc private func mediaPlayButtonTouched(_ sender: UITapGestureRecognizer) {
        viewModel?.mediaPlayButtonTouched()
        print(#function)
    }
    
    @objc private func bottomViewDragged(_ sender: UIPanGestureRecognizer) {
        if sender.state != .ended { return }
        
        let moveY = sender.translation(in: sender.view).y
        
        if (self.isAttached && moveY > 0) || (!self.isAttached && moveY < 0) {
            self.isAttached = true
            self.mainScrollView.setContentOffset(
                CGPoint(x: 0, y: self.mediaControlViewHeight - SystemConstants.statusBarHeight),
                animated: true
            )
        } else {
            if self.isAttached { return }
            
            if moveY > 0 {
                self.isAttached = false
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: -SystemConstants.statusBarHeight), animated: true)
            }
        }
    }
    
    @objc private func modeSwitchTouched(_ sender: UIButton) {
        viewModel?.modeSwitchTouched()
    }
    
    @objc private func focusButtonTouched(_ sender: UITapGestureRecognizer) {
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentsOffsetY = scrollView.contentOffset.y
        let currentTopBottomYGap = mediaControlViewHeight - (currentContentsOffsetY + SystemConstants.statusBarHeight)
        
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
        
        mediaBackgroundView.alpha = currentTopBottomYGap / mediaControlViewHeight
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

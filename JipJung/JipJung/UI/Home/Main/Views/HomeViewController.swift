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
import SpriteKit

final class HomeViewController: UIViewController {
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
    private lazy var maximButton: UIButton = {
        let button = UIButton()
        button.setTitle("하루 한 줄, 오늘의 명언", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.makeBlurBackground()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    private lazy var playHistoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        let cellWidth = UIScreen.deviceScreenSize.width / 2.5
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * MediaCell.ratio)
        layout.minimumInteritemSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MediaCollectionViewCell.self)
        return collectionView
    }()
    private lazy var playHistoryEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 재생 기록이 없습니다."
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    private lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        let cellWidth = UIScreen.deviceScreenSize.width / 2.5
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * MediaCell.ratio)
        layout.minimumInteritemSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MediaCollectionViewCell.self)
        return collectionView
    }()
    private lazy var favoriteEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아요를 누른 음원이 없습니다."
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    private lazy var touchTransferView = TouchTransferView()
    private lazy var clubView = SKView()
    private lazy var clubScene: SKScene = {
        let skScene = ClubSKScene()
        skScene.size = CGSize(
            width: view.frame.width,
            height: view.frame.height
        )
        skScene.scaleMode = .fill
        return skScene
    }()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private var topBottomViewGap: CGFloat = 0
    private var isAttached = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindUI()
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let media = carouselView.getMediaFromCurrentView() else { return }
        
        if viewModel.mediaPlayViewAppear(media: media) {
            carouselView.playVideoInCurrentView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        carouselView.pauseVideoInCurrentView()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        configureObserver()
        configureTopBottomViewGap()
        configureMainScrollView()
        configureCarouselView()
        configureMediaControlBackgroundView()
        configureTopView()
        configureBottomView()
        configureCollectionViews()
        configureTouchTransferView()
        configureClubView()
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh(_:)),
            name: .refreshHome,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controlForFocus(_:)),
            name: .controlForFocus,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showCarouselView(_:)),
            name: .showCarouselView,
            object: nil
        )
    }
    
    private func configureTopBottomViewGap() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        let betweenSpace = (
            UIScreen.deviceScreenSize.height
            - UIApplication.statusBarHeight
            - HomeMainViewSize.topViewHeight
            - tabBarHeight
            - UIApplication.bottomIndicatorHeight
            - 23) // TODO: 어디서 비는지 알 수 없는 여백, 12P와 12PM 동일
        topBottomViewGap = betweenSpace - 124
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
        carouselView.delegate = self
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
            let configuration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title1))
            button.setImage(
                UIImage(systemName: "repeat.circle.fill", withConfiguration: configuration),
                for: .normal
            )
            button.tintColor = .white
            return button
        }()
        
        modeSwitch.rx.tap
            .bind {
                ApplicationMode.shared.convert()
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
                topBottomViewGap + HomeMainViewSize.topViewHeight
            )
            $0.leading.trailing.bottom.equalToSuperview()
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
            $0.top.equalTo(focusButtonStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(70)
        }
    }
    
    private func configureCollectionViews() {
        let recentPlayHistoryHeader = HomeListHeaderView()
        recentPlayHistoryHeader.titleLabel.text = "재생 기록"
        recentPlayHistoryHeader.allButton.rx.tap
            .bind { [weak self] in
                if self?.viewModel.recentPlayHistory.value.count == 0 {
                    return
                }
                let playHistoryNavigationView = UINavigationController(
                    rootViewController: PlayHistoryViewController()
                )
                playHistoryNavigationView.modalPresentationStyle = .pageSheet
                playHistoryNavigationView.modalTransitionStyle = .coverVertical
                self?.present(playHistoryNavigationView, animated: true)
            }
            .disposed(by: disposeBag)
        bottomView.addSubview(recentPlayHistoryHeader)
        recentPlayHistoryHeader.snp.makeConstraints {
            $0.top.equalTo(maximButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        bottomView.addSubview(playHistoryCollectionView)
        playHistoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentPlayHistoryHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(220)
        }
        
        bottomView.addSubview(playHistoryEmptyLabel)
        playHistoryEmptyLabel.snp.makeConstraints {
            $0.center.equalTo(playHistoryCollectionView)
        }
        
        let favoriteHeader = HomeListHeaderView()
        favoriteHeader.titleLabel.text = "좋아요 누른 음원"
        favoriteHeader.allButton.rx.tap
            .bind { [weak self] in
                if self?.viewModel.favoriteSoundList.value.count == 0 {
                    return
                }
                let favoriteNavigationView = UINavigationController(
                    rootViewController: FavoriteViewController()
                )
                favoriteNavigationView.modalPresentationStyle = .pageSheet
                favoriteNavigationView.modalTransitionStyle = .coverVertical
                self?.present(favoriteNavigationView, animated: true)
            }
            .disposed(by: disposeBag)
        
        bottomView.addSubview(favoriteHeader)
        favoriteHeader.snp.makeConstraints {
            $0.top.equalTo(playHistoryCollectionView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        bottomView.addSubview(favoriteCollectionView)
        favoriteCollectionView.snp.makeConstraints {
            $0.top.equalTo(favoriteHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(220)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        bottomView.addSubview(favoriteEmptyLabel)
        favoriteEmptyLabel.snp.makeConstraints {
            $0.center.equalTo(favoriteCollectionView)
        }
    }
    
    private func configureTouchTransferView() {
        touchTransferView.transferView = carouselView
        view.addSubview(touchTransferView)
        touchTransferView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(
                HomeMainViewSize.topViewHeight + UIApplication.statusBarHeight
            )
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(topBottomViewGap)
        }
    }
    
    private func configureClubView() {
        clubView.isHidden = true
        
        carouselView.addSubview(clubView)
        clubView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
        
        clubView.presentScene(clubScene)
    }
    
    private func bindUI() {
        bindUIWithView()
        bindUIWithViewModel()
    }
    
    private func bindUIWithView() {
        maximButton.rx.tap
            .bind { [weak self] in
                let maximViewController = MaximViewController()
                maximViewController.modalPresentationStyle = .overCurrentContext
                self?.present(maximViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.of(
            playHistoryCollectionView.rx.modelSelected(Media.self),
            favoriteCollectionView.rx.modelSelected(Media.self)
        )
            .merge()
            .subscribe(onNext: { [weak self] media in
                let musicPlayerView = MediaPlayerViewController(
                    viewModel: MediaPlayerViewModel(
                        media: media
                    )
                )
                musicPlayerView.modalPresentationStyle = .pageSheet
                musicPlayerView.modalTransitionStyle = .coverVertical
                self?.present(musicPlayerView, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUIWithViewModel() {
        viewModel.currentModeList
            .distinctUntilChanged()
            .bind { [weak self] mediaList in
                self?.carouselView.replaceContents(contents: mediaList)
            }
            .disposed(by: disposeBag)
        
        let playHistoryObservable = viewModel.recentPlayHistory
            .distinctUntilChanged()
        
        playHistoryObservable
            .map { $0.isEmpty }
            .bind { [weak self] state in
                self?.playHistoryEmptyLabel.isHidden = !state
            }.disposed(by: disposeBag)

        playHistoryObservable
            .bind(
                to: playHistoryCollectionView.rx.items(
                    cellIdentifier: MediaCollectionViewCell.identifier
                )
            ) { (_, element, cell) in
                guard let cell = cell as? MediaCollectionViewCell else { return }

                cell.titleView.text = element.name
                cell.imageView.image = UIImage(named: element.thumbnailImageFileName)
                cell.backgroundColor = UIColor(
                    rgb: Int(element.color, radix: 16) ?? 0xFFFFFF,
                    alpha: 1.0
                )
            }.disposed(by: disposeBag)
        
        let favoriteObservable = viewModel.favoriteSoundList
            .distinctUntilChanged()
        
        favoriteObservable
            .map { $0.isEmpty }
            .bind { [weak self] state in
                self?.favoriteEmptyLabel.isHidden = !state
            }.disposed(by: disposeBag)

        favoriteObservable
            .distinctUntilChanged()
            .bind(
                to: favoriteCollectionView.rx.items(
                    cellIdentifier: MediaCollectionViewCell.identifier
                )
            ) { (_, element, cell) in
                guard let cell = cell as? MediaCollectionViewCell else { return }
                
                cell.titleView.text = element.name
                cell.imageView.image = UIImage(named: element.thumbnailImageFileName)
                cell.backgroundColor = UIColor(
                    rgb: Int(element.color, radix: 16) ?? 0xFFFFFF,
                    alpha: 1.0
                )
            }.disposed(by: disposeBag)
        
        ApplicationMode.shared.mode
            .skip(1)
            .distinctUntilChanged()
            .bind { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .bright:
                    self.viewModel.mode.accept(.bright)
                    self.clubView.isHidden = true
                case .dark:
                    self.viewModel.mode.accept(.dark)
                    self.clubView.isHidden = false
                    UIView.animate(
                        withDuration: 0.35,
                        delay: 0,
                        options: [.autoreverse, .repeat]
                    ) {
                        self.clubScene.view?.layer.opacity = 0.25
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func mediaPlayButtonTouched(media: Media) -> Single<Bool> {
        return viewModel.mediaPlayViewTapped(media: media)
    }
    
    @objc private func refresh(_ sender: Notification) {
        guard let typeList = sender.userInfo?["RefreshType"] as? [RefreshHomeData] else { return }

        viewModel.refresh(typeList: typeList)
    }
    
    @objc private func controlForFocus(_ sender: Notification) {
        guard let playState = sender.userInfo?["PlayState"] as? Bool,
              let media = carouselView.getMediaFromCurrentView()
        else {
            return
        }
        
        viewModel.receiveNotificationForFocus(media: media, state: playState)
    }
    
    @objc private func showCarouselView(_ sender: Notification) {
        guard let media = carouselView.getMediaFromCurrentView() else { return }
        
        if viewModel.mediaPlayViewAppear(media: media) {
            carouselView.playVideoInCurrentView()
        }
    }
    
    @objc private func bottomViewDragged(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        let moveY = sender.translation(in: sender.view).y
        if (self.isAttached && moveY > 50) || (!self.isAttached && moveY < 50) {
            self.isAttached = true
            self.mainScrollView.setContentOffset(
                CGPoint(x: 0, y: topBottomViewGap - UIApplication.statusBarHeight),
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
        let currentTopBottomYGap = topBottomViewGap - (currentContentsOffsetY + UIApplication.statusBarHeight)

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
        let totalHeight = topBottomViewGap
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
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return SlowPresent(duration: 0.5, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlowPresent(duration: 0.5, animationType: .dismiss)
    }
}

extension HomeViewController: CarouselViewDelegate {
    func currentViewTapped(media: Media) {
        mediaPlayButtonTouched(media: media)
            .subscribe { [weak self] state in
                if state {
                    self?.carouselView.playVideoInCurrentView()
                } else {
                    self?.carouselView.pauseVideoInCurrentView()
                }
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func currentViewDownSwiped(media: Media) {
        guard let mode = MediaMode(rawValue: media.mode) else { return }
        
        let alert = UIAlertController(
            title: "목록에서 음원 삭제",
            message: "\(media.name) 음원을 목록에서 삭제할까요?\n다운로드된 파일은 삭제되지않습니다.",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let okAction = UIAlertAction(title: "네", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.mediaPlayViewDownSwiped(media: media)
                .subscribe { state in
                    if state {
                        NotificationCenter.default.post(
                            name: .refreshHome,
                            object: nil,
                            userInfo: [
                                "RefreshType": [
                                    mode == .bright ? RefreshHomeData.brightMode : RefreshHomeData.darkMode
                                ]
                            ]
                        )
                    } else {
                        let alert = UIAlertController(
                            title: "삭제 실패",
                            message: "음원 목록에는 최소 1개 이상의 음원이 있어야합니다.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
                        self.present(alert, animated: true)
                    }
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: self.disposeBag)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func currentViewAppear(media: Media) {
        if viewModel.mediaPlayViewAppear(media: media) {
            carouselView.playVideoInCurrentView()
        }
    }
}

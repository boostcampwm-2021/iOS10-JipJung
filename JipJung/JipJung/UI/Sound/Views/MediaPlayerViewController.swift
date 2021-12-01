//
//  MediaPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import AVKit
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import SpriteKit

final class MediaPlayerViewController: UIViewController {
    private lazy var navigationBar = UINavigationBar()
    private lazy var backButton = BackCircleButton()
    private lazy var favoriteButton = FavoriteCircleButton()
    private lazy var topView = UIView()
    private lazy var mediaDescriptionView = MediaDescriptionView()
    private lazy var tagCollectionView: UICollectionView = {
        let layout = LeftAlignCollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.register(
            TagCollectionViewCell.self,
            forCellWithReuseIdentifier: TagCollectionViewCell.identifier
        )
        return collectionView
    }()
    private lazy var bottomView = UIView()
    private lazy var maximTextView = MediaPlayerMaximView()
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    private lazy var clubView = SKView()
    
    private let themeColor = CGColor(red: 34.0/255.0, green: 48.0/255.0, blue: 74.0/255.0, alpha: 1)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var viewModel: MediaPlayerViewModel?
    private let disposeBag = DisposeBag()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?
    private lazy var clubScene: SKScene = {
        let clubScene = ClubSKScene()
        clubScene.size = CGSize(
            width: view.frame.width,
            height: view.frame.height
        )
        clubScene.scaleMode = .fill
        return clubScene
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel?.checkMediaMode()
        configureUI()
        bindUI()
        viewModel?.checkMusicDownloaded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.pauseMusic()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = topView.bounds
    }
    
    convenience init(viewModel: MediaPlayerViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    private func configureUI() {
        tabBarController?.tabBar.isHidden = true
        if ApplicationMode.shared.mode.value == .dark {
            configureClubView()
        }
        configureTopView()
        configureBottomView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .clear
        navigationBar.items = [navigationItem]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.size.equalTo(30)
        }
    }
    
    private func configureTopView() {
        switch ApplicationMode.shared.mode.value {
        case .bright:
            configureVideoView()
        case .dark:
            topView.backgroundColor = .clear
            mediaDescriptionView.gradientLayer.removeFromSuperlayer()
        }
        
        self.view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.width).multipliedBy(1.2)
        }
        
        topView.addSubview(mediaDescriptionView)
        mediaDescriptionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(115)
        }
        mediaDescriptionView.titleLabel.text = viewModel?.title
        mediaDescriptionView.explanationLabel.text = viewModel?.explanation
        
        mediaDescriptionView.tagView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    private func configureVideoView() {
        if let playerItem = viewModel?.videoPlayerItem {
            queuePlayer = AVQueuePlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: self.queuePlayer)
            guard let playerLayer = playerLayer,
                  let queuePlayer = queuePlayer
            else {
                return
            }
            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            playerLayer.videoGravity = .resizeAspectFill
        }
        
        let backgroundView = UIView()
        topView.addSubview(backgroundView)
        backgroundView.backgroundColor = .clear
        if let playerLayer = self.playerLayer,
           let queuePlayer = self.queuePlayer {
            backgroundView.layer.addSublayer(playerLayer)
            queuePlayer.play()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureBottomView() {
        bottomView.layer.backgroundColor = themeColor
        playButton.setTitleColor(UIColor(cgColor: themeColor), for: .normal)
        
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        
        bottomView.addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(44)
        }
        
        let maximContainerView = UIView()
        
        switch ApplicationMode.shared.mode.value {
        case .dark:
            bottomView.backgroundColor = .clear
        case .bright:
            let colorHexString = viewModel?.color ?? "FFFFFF"
            bottomView.backgroundColor = UIColor(
                rgb: Int(colorHexString, radix: 16) ?? 0xFFFFFF,
                alpha: 1.0
            )
        }
        
        bottomView.addSubview(maximContainerView)
        maximContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(playButton.snp.top).offset(-12)
        }
        
        maximTextView.maximLabel.text = viewModel?.maxim
        maximTextView.speakerNameLabel.text = viewModel?.speaker
        
        maximContainerView.addSubview(maximTextView)
        maximTextView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureClubView() {
        view.addSubview(clubView)
        clubView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
        
        clubView.presentScene(clubScene)
    }
    
    private func bindUI() {
        backButton.rx.tap
            .bind { [weak self] in
                if let navigationController = self?.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let playButtonTitle = self.playButton.title(for: .normal)
                if playButtonTitle == "Pause" {
                    self.viewModel?.pauseMusic()
                } else if playButtonTitle == "Play" {
                    self.viewModel?.playMusic()
                } else if playButtonTitle == "Download To Play" {
                    self.playButton.setTitle("Downloading....", for: .normal)
                    self.viewModel?.playMusic()
                }
            }
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.toggleFavoriteState()
            }
            .disposed(by: disposeBag)
        
        mediaDescriptionView.plusButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.mediaDescriptionView.plusButton.isSelected.toggle()
                
                if self.mediaDescriptionView.plusButton.isSelected {
                    self.viewModel?.saveMediaFromMode()
                } else {
                    self.viewModel?.removeMediaFromMode()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel?.musicFileStatus
            .distinctUntilChanged()
            .bind(onNext: { [weak self] state in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch state {
                    case .isNotDownloaded:
                        self.playButton.setTitle("Download To Play", for: .normal)
                    case .downloaded:
                        self.playButton.setTitle("Play", for: .normal)
                        self.mediaDescriptionView.plusButton.isEnabled = true
                    case .downloadFailed:
                        self.playButton.setTitle("Download Failed", for: .normal)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.isMusicPlaying
            .skip(1)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] state in
                DispatchQueue.main.async {
                    if state {
                        self?.playButton.setTitle("Pause", for: .normal)
                    } else {
                        self?.playButton.setTitle("Play", for: .normal)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.isFavorite
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                self?.favoriteButton.isSelected = $0
            })
            .disposed(by: disposeBag)
        
        viewModel?.isInMusicList
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                self?.mediaDescriptionView.plusButton.isSelected = $0
            })
            .disposed(by: disposeBag)
    }
}

extension MediaPlayerViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel?.tag.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.tagLabel.text = viewModel?.tag[indexPath.item]
        return cell
    }
}

extension MediaPlayerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = viewModel?.tag[indexPath.item]
        label.sizeToFit()
        
        let size = label.frame.size
        
        return CGSize(width: size.width + 16, height: size.height + 10)
    }
}

class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        
        return attributes
    }
}

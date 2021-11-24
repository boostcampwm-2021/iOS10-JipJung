//
//  MusicPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import AVKit
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MusicPlayerViewController: UIViewController {
    private let themeColor = CGColor(red: 34.0/255.0, green: 48.0/255.0, blue: 74.0/255.0, alpha: 1)
    private let navigationBar = UINavigationBar()
    private let backButton = BackCircleButton()
    private let favoriteButton = FavoriteCircleButton()
    private let topView = UIView()
    private let musicDescriptionView = MusicDescriptionView()
    private let tagCollectionView: UICollectionView = {
        let layout = LeftAlignCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        return collectionView
    }()
    private let bottomView = UIView()
    private let maximTextView = MusicPlayerMaximView()
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .white
        button.setTitle("Download To Play", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private Variables
    
    private var viewModel: MusicPlayerViewModel?
    private var disposeBag: DisposeBag = DisposeBag()
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?
    private var playerLayer: AVPlayerLayer?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        configureUI()
        bindUI()
        viewModel?.checkMusicDownloaded()
        viewModel?.checkMusicPlaying()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = topView.bounds
    }
    
    // MARK: - Initializer

    convenience init(viewModel: MusicPlayerViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    private func configureUI() {
        tabBarController?.tabBar.isHidden = true
        configureTopView()
        configureBottomView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .clear
        navigationBar.items = [navigationItem]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    private func configureTopView() {
        configureVideoView()
                
        self.view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(1.2)
        }
        
        topView.addSubview(musicDescriptionView)
        musicDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(115)
        }
        musicDescriptionView.titleLabel.text = viewModel?.title
        musicDescriptionView.explanationLabel.text = viewModel?.explanation
        
        musicDescriptionView.tagView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureBottomView() {
        bottomView.layer.backgroundColor = themeColor
        playButton.setTitleColor(UIColor(cgColor: themeColor), for: .normal)
        
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        bottomView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(44)
        }
        
        let maximContainerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let colorHexString = viewModel?.color ?? "FFFFFF"
        bottomView.backgroundColor = UIColor(rgb: Int(colorHexString, radix: 16) ?? 0xFFFFFF,
                                             alpha: 1.0)
        
        bottomView.addSubview(maximContainerView)
        maximContainerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(playButton.snp.top).offset(-12)
        }
        
        maximTextView.maximLabel.text = viewModel?.maxim
        maximTextView.speakerNameLabel.text = viewModel?.speaker
        
        maximContainerView.addSubview(maximTextView)
        maximTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
                    self.viewModel?.playMusic()
                }
            }
            .disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.toggleFavoriteState()
            }
            .disposed(by: disposeBag)
        
        viewModel?.musicFileStatus
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .isNotDownloaded:
                    self.playButton.setTitle("Download To Play", for: .normal)
                case .downloaded:
                    self.playButton.setTitle("Play", for: .normal)
                case .downloadFailed:
                    self.playButton.setTitle("Download Failed", for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.isMusicPlaying
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                switch $0 {
                case true:
                    self?.playButton.setTitle("Pause", for: .normal)
                case false:
                    self?.playButton.setTitle("Play", for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.isFavorite
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                self?.favoriteButton.isSelected = $0
            })
            .disposed(by: disposeBag)
    }
}

extension MusicPlayerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.tag.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath
        ) as? TagCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = viewModel?.tag[indexPath.item]

        return cell
    }
}

extension MusicPlayerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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

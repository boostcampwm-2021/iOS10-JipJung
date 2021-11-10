//
//  MusicPlayerViewController.swift
//  JipJung
//
//  Created by turu on 2021/11/04.
//

import AVKit
import UIKit

import SnapKit

class MusicPlayerViewController: UIViewController {
    // MARK: - View builder -> 임시 코드가 포함됨
    let dataSource = ["Relax", "Melody", "Meditation", "Etc"]
    let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        return navigationBar
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()
    
    var musicDescriptionView: MusicDescriptionView = {
        let view = MusicDescriptionView()
        view.backgroundColor = .green
        return view
    }()
    
    let maximView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        return view
    }()
    
    let maximTextView: PlayerMaximView = {
        let view = PlayerMaximView()
        return view
    }()
    
    let playButton: UIButton = {
        let button = SolidButton()
        button.backgroundColor = .systemGray6
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    var collectionView: UICollectionView = {
        let layout = LeftAlignCollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        return collectionView
    }()
    
    var audioPlayer: AVAudioPlayer?
    
    var playerLooper: AVPlayerLooper?
    var queuePlayer: AVQueuePlayer?
    var playerLayer: AVPlayerLayer?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        configureUI()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        playButton.addTarget(self, action: #selector(playButtonTouched(_:)), for: .touchUpInside)
    }
    
    func configureUI() {
        setTopView()
        setBottomView()
        setNavigationBar()
    }
    
    // MARK: - Input vent from views
    @objc func favoriteButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
    
    @objc func streamingButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
    
    @objc func playButtonTouched(_ sender: UIButton) {
        print(#function, #line)
    }
    
    @objc func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AddSubView + Constraints
extension MusicPlayerViewController {
    func setNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .clear
        
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        let navigationItem = UINavigationItem()
        navigationBar.items = [navigationItem]
        
        let leftButton = PlayerBackButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        let rightButton = HeartButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    func setTopView() {
        setVideoView()
                
        self.view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(1.2)
        }
        
        topView.addSubview(musicDescriptionView)
        musicDescriptionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(12)
            make.height.equalTo(105)
        }
        
        musicDescriptionView.tagView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setVideoView() {
        guard let videoURL = Bundle.main.url(forResource: "sea", withExtension: "mp4")
        else {
            return
        }

        let playerItem = AVPlayerItem(url: videoURL)
        queuePlayer = AVQueuePlayer(items: [playerItem])
        playerLayer = AVPlayerLayer(player: self.queuePlayer)
        
        guard let playerLayer = playerLayer,
              let queuePlayer = queuePlayer
        else {
            return
        }
        
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        playerLayer.videoGravity = .resizeAspectFill

        let backgroundView = UIView()
        topView.addSubview(backgroundView)
        backgroundView.backgroundColor = .red
        backgroundView.layer.addSublayer(playerLayer)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        queuePlayer.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = topView.bounds
    }
    
    func setBottomView() {
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
        
        bottomView.addSubview(maximView)
        maximView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(playButton.snp.top).offset(-12)
        }
        
        maximView.addSubview(maximTextView)
        maximTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

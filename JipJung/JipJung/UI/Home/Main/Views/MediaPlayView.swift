//
//  MediaPlayView.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/18.
//

import AVKit
import UIKit

import RxRelay
import RxSwift

final class MediaPlayView: UIView {
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 45))
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: configuration), for: .normal)
        button.tintColor = .white.withAlphaComponent(0.5)
        button.isUserInteractionEnabled = false
        return button
    }()
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var videoPlayer = AVQueuePlayer()
    private var playerLooper: AVPlayerLooper?
    
    private let viewModel = MediaPlayViewModel()
    private let disposeBag = DisposeBag()
    let media = BehaviorRelay<Media?>(value: nil)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        bindUI()
    }
    
    init(media: Media) {
        super.init(frame: .zero)
        
        configureUI()
        bindUI()
        
        self.media.accept(media)
    }
    
    private func configureUI() {
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailImageView.addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIScreen.deviceScreenSize.height * 0.4)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }
    }
    
    private func bindUI() {
        media
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { [weak self] media in
                self?.pauseVideo()
                self?.setMedia(media: media)
            })
            .disposed(by: disposeBag)
    }
    
    func replaceMedia(media: Media) {
        self.media.accept(media)
    }
    
    func playVideo() {
        playButton.isHidden = true
        guard videoPlayer.currentItem != nil else { return }
        videoPlayer.currentItem?.seek(to: .zero, completionHandler: nil)
        videoPlayer.play()
    }
    
    func pauseVideo() {
        playButton.isHidden = false
        guard videoPlayer.currentItem != nil else { return }
        videoPlayer.pause()
    }
    
    private func setMedia(media: Media) {
        guard media.mode == ApplicationMode.shared.mode.value.rawValue else { return }
        
        switch ApplicationMode.shared.mode.value {
        case .bright:
            viewModel.didSetMedia(fileName: media.videoFileName, type: .video)
                .subscribe { [weak self] url in
                    guard let self = self else { return }
                    
                    let playerItem = AVPlayerItem(url: url)
                    self.videoPlayer.replaceCurrentItem(with: playerItem)
                    self.playerLooper = AVPlayerLooper(player: self.videoPlayer, templateItem: playerItem)
                    
                    let avPlayerLayer = AVPlayerLayer(player: self.videoPlayer)
                    avPlayerLayer.videoGravity = .resizeAspectFill
                    avPlayerLayer.frame = UIScreen.main.bounds
                    
                    self.thumbnailImageView.image = nil
                    self.layer.sublayers = [avPlayerLayer, self.thumbnailImageView.layer]
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        case .dark:
            viewModel.didSetMedia(fileName: media.thumbnailImageFileName, type: .image)
                .subscribe { [weak self] url in
                    guard let self = self else { return }
                    
                    self.videoPlayer.replaceCurrentItem(with: nil)
                    self.layer.sublayers = [self.thumbnailImageView.layer]
                    if let imageData = try? Data(contentsOf: url) {
                        self.thumbnailImageView.image = UIImage(data: imageData)
                    }
                    self.layer.sublayers = [self.thumbnailImageView.layer]
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        }
        
    }
}

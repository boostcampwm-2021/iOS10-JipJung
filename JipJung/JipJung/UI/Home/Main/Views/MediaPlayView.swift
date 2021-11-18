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
    private var playerLooper: AVPlayerLooper?
    private var videoPlayer: AVQueuePlayer? {
        didSet {
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = UIScreen.main.bounds
            layer.sublayers = [playerLayer, playButton.layer]
        }
    }
    
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
        addSubview(playButton)
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
        guard let videoPlayer = videoPlayer else { return }
        videoPlayer.currentItem?.seek(to: .zero, completionHandler: nil)
        videoPlayer.play()
        playButton.isHidden = true
    }
    
    func pauseVideo() {
        guard let videoPlayer = videoPlayer else { return }
        videoPlayer.pause()
        playButton.isHidden = false
    }
    
    private func setMedia(media: Media) {
        viewModel.didSetMedia(media: media)
            .subscribe { [weak self] url in
                guard let self = self else { return }
                
                let playerItem = AVPlayerItem(url: url)
                self.videoPlayer = AVQueuePlayer(playerItem: playerItem)
                
                if let videoPlayer = self.videoPlayer {
                    self.playerLooper = AVPlayerLooper(player: videoPlayer, templateItem: playerItem)
                }
                
                let playerLayer = AVPlayerLayer(player: self.videoPlayer)
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.frame = UIScreen.main.bounds
                self.layer.sublayers = [playerLayer, self.playButton.layer]
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

class MediaPlayViewModel {
    private let videoPlayUseCase = VideoPlayUseCase()
    
    func didSetMedia(media: Media) -> Single<URL> {
        return videoPlayUseCase.ready(media.videoFileName)
    }
}

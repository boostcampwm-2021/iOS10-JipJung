//
//  MediaCollectionViewCell.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/09.
//

import AVKit
import UIKit

final class MediaCollectionViewCell: UICollectionViewCell {
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
    private var videoURL: URL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playButton.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
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
    
    func setVideo(videoURL: URL) {
        if videoURL == self.videoURL {
            return
        }
        
        self.videoURL = videoURL
        let playerItem = AVPlayerItem(url: videoURL)
        videoPlayer = AVQueuePlayer(playerItem: playerItem)
        
        if let videoPlayer = videoPlayer {
            videoPlayer.isMuted = true
            playerLooper = AVPlayerLooper(player: videoPlayer, templateItem: playerItem)
        }
    }
    
    private func configureUI() {
        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIScreen.deviceScreenSize.height * 0.4)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }
    }
}

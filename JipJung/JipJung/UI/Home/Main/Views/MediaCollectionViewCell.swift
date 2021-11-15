//
//  MediaCollectionViewCell.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/09.
//

import AVKit
import UIKit

final class MediaCollectionViewCell: UICollectionViewCell {
    static let identifier = "MediaCollectionViewCell"
    
    private var videoPlayer: AVPlayer? {
        didSet {
            let playerLayer = AVPlayerLayer(player: videoPlayer)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = UIScreen.main.bounds
            layer.addSublayer(playerLayer)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: videoPlayer?.currentItem
        )
        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        videoPlayer = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func playVideo() {
        guard let videoPlayer = videoPlayer else { return }
        videoPlayer.currentItem?.seek(to: .zero, completionHandler: nil)
        videoPlayer.play()
    }
    
    func pauseVideo() {
        guard let videoPlayer = videoPlayer else { return }
        videoPlayer.pause()
    }
    
    func setVideo(videoURL: URL) {
        videoPlayer = AVPlayer(url: videoURL)
        videoPlayer?.actionAtItemEnd = .none
        videoPlayer?.isMuted = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: videoPlayer?.currentItem
        )
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
}

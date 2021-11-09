//
//  MediaCollectionViewCell.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/09.
//

import AVKit
import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    static let identifier = "MediaCollectionViewCell"
    
    private var videoPlayer: AVPlayer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoPlayer = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    private func configureUI() {
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        layer.addSublayer(playerLayer)
    }
    
    func setVideo(videoURL: URL) {
        videoPlayer = AVPlayer(url: videoURL)
        videoPlayer?.actionAtItemEnd = .none
    }
}

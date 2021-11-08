//
//  HomeViewController.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/03.
//
import AVKit
import UIKit

import SnapKit

class HomeViewController: UIViewController {
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
    
    private var videoPlayer: AVPlayer?
    private var audioPlayer: AVAudioPlayer?
    
    private var isAttached = false
    private var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        configureMediaContentsView()
        configureMainScrollView()
        configureTopView()
        configureBottomView()
        configureMediaControllView()
    }
    
    private func configureMediaContentsView() {
        guard let videoURL = Bundle.main.url(forResource: "test", withExtension: "mp4"),
              let soundURL = Bundle.main.url(forResource: "testSound", withExtension: "m4a")
        else {
            return
        }
        
        videoPlayer = AVPlayer(url: videoURL)
        audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
        
        videoPlayer?.actionAtItemEnd = .none
        audioPlayer?.numberOfLoops = -1
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: videoPlayer?.currentItem
        )
        
        view.addSubview(mediaBackgroundView)
        mediaBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        mediaBackgroundView.layer.addSublayer(playerLayer)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    
    private func configureMainScrollView() {
        mainScrollView.delegate = self
        
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
    
    private func configureTopView() {
        view.addSubview(topView)
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
    
    private func configureMediaControllView() {
        mediaControllView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mediaButton(_:))))
        mediaControllView.addGestureRecognizer(UIPanGestureRecognizer(target: nil, action: nil))
        
        mainScrollContentsView.addSubview(mediaControllView)
        mediaControllView.snp.makeConstraints {
            $0.height.equalTo(mediaControlViewHeight)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    @objc private func mediaButton(_ sender: UITapGestureRecognizer) {
        if isPlaying {
            audioPlayer?.pause()
            videoPlayer?.pause()
        } else {
            audioPlayer?.play()
            videoPlayer?.play()
        }
        isPlaying.toggle()
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

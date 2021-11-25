//
//  CarouselView.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/18.
//

import UIKit

import RxRelay
import RxSwift
import SnapKit

protocol CarouselViewDelegate: AnyObject {
    func currentViewTapped()
    func currentViewAppear(audioFileName: String, autoPlay: Bool)
}

class CarouselView: UIView {
    enum ScrollDirection: CGFloat {
        case left = -1
        case right = 1
        case none = 0
    }
    
    private lazy var previousView = MediaPlayView()
    private lazy var currentView = MediaPlayView()
    private lazy var nextView = MediaPlayView()
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private let disposeBag = DisposeBag()
    private let contents = BehaviorRelay<[Media]>(value: [])
    private let currentIndex = BehaviorRelay<Int>(value: 0)
    
    private var startPoint: CGPoint = .zero
    
    weak var delegate: CarouselViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        bindUI()
    }
    
    func getMediaFromCurrentView() -> Media? {
        return currentView.media.value
    }
    
    func playVideoInCurrentView() {
        currentView.playVideo()
    }
    
    func pauseVideoInCurrentView() {
        currentView.pauseVideo()
    }
    
    func replaceContents(contents: [Media]) {
        pageControl.numberOfPages = contents.count
        self.currentIndex.accept(contents.count/2)
        self.contents.accept(contents)
    }
    
    private func configureUI() {
        backgroundColor = .brown
        
        addSubview(previousView)
        previousView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-UIScreen.deviceScreenSize.width)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        addSubview(currentView)
        currentView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        addSubview(nextView)
        nextView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(UIScreen.deviceScreenSize.width)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-200 - UIApplication.bottomIndicatorHeight)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
    
    private func bindUI() {
        
        let contentsObservable = contents
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
        
        let currentIndexObservable = currentIndex
            .distinctUntilChanged()
        
        currentIndexObservable
            .bind { [weak self] index in
                self?.pageControl.currentPage = index
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(contentsObservable, currentIndexObservable)
            .subscribe { [weak self] contents, currentIndex in
                guard let previousItem = contents[loop: currentIndex - 1],
                      let currentItem = contents[loop: currentIndex],
                      let nextItem = contents[loop: currentIndex + 1]
                else {
                    return
                }

                self?.applyContents(
                    previousItem: previousItem,
                    currentItem: currentItem,
                    nextItem: nextItem
                )
                
                self?.mediaPlayViewAppear(autoPlay: false)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func applyContents(
        previousItem: Media,
        currentItem: Media,
        nextItem: Media
    ) {
        if contents.value.count != 1 {
            previousView.replaceMedia(media: previousItem)
            nextView.replaceMedia(media: nextItem)
        }
        currentView.replaceMedia(media: currentItem)
    }
    
    private func move(distanceX: CGFloat) {
        guard contents.value.count != 1 else {
            return
        }
        previousView.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(distanceX - UIScreen.deviceScreenSize.width)
        }
        currentView.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(distanceX)
        }
        nextView.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(distanceX + UIScreen.deviceScreenSize.width)
        }
        
        // Reference: iOS05-Escaper의 3주차 데모 발표 QnA
        let leftDistance = abs(distanceX)
        let rightDistance = abs(UIScreen.deviceScreenSize.width - distanceX)
        let distance = min(leftDistance, rightDistance) / UIScreen.deviceScreenSize.width
        let distanceRatio = min(0.1, distance)
        
        [
            previousView,
            currentView,
            nextView
        ].forEach {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 40 * (distanceRatio * 10)
            $0.transform = CGAffineTransform(scaleX: 1 - distanceRatio, y: 1 - distanceRatio)
        }
    }
    
    private func applyPaging(with scrollDirection: ScrollDirection) {
        guard contents.value.count != 1 else {
            return
        }
        
        switch scrollDirection {
        case .left:
            previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.deviceScreenSize.width * 2)
            }
            currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.deviceScreenSize.width)
            }
            nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
        case .right:
            previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
            currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.deviceScreenSize.width)
            }
            nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.deviceScreenSize.width * 2)
            }
        case .none:
            previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.deviceScreenSize.width)
            }
            currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
            nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.deviceScreenSize.width)
            }
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
            
            [
                self?.previousView,
                self?.currentView,
                self?.nextView
            ].forEach {
                $0?.layer.masksToBounds = false
                $0?.layer.cornerRadius = 0
                $0?.transform = CGAffineTransform.identity
            }
            
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            switch scrollDirection {
            case .left:
                let currentIndex = self.currentIndex.value
                let contentsCount = self.contents.value.count
                let nextIndex = (currentIndex + 1) % contentsCount

                let tempView = self.previousView
                self.previousView = self.currentView
                self.currentView = self.nextView
                self.nextView = tempView
                
                self.currentIndex.accept(nextIndex)
                
                self.previousView.pauseVideo()
                self.currentView.pauseVideo()
                self.nextView.pauseVideo()
                
                self.mediaPlayViewTapped()
            case .right:
                let currentIndex = self.currentIndex.value
                let contentsCount = self.contents.value.count
                let nextIndex = (contentsCount + currentIndex - 1) % contentsCount
                
                let tempView = self.nextView
                self.nextView = self.currentView
                self.currentView = self.previousView
                self.previousView = tempView
                
                self.currentIndex.accept(nextIndex)
                
                self.previousView.pauseVideo()
                self.currentView.pauseVideo()
                self.nextView.pauseVideo()
                
                self.mediaPlayViewTapped()
            case .none:
                break
            }
            
            self.previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.deviceScreenSize.width)
            }
            self.currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
            self.nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.deviceScreenSize.width)
            }
        }
    }
    
    private func mediaPlayViewTapped() {
        guard let delegate = delegate,
              let media = currentView.media.value
        else {
            return
        }

        delegate.currentViewTapped()
    }
    
    private func mediaPlayViewAppear(autoPlay: Bool) {
        guard let delegate = delegate,
              let media = currentView.media.value
        else {
            return
        }

        delegate.currentViewAppear(audioFileName: media.audioFileName, autoPlay: autoPlay)
    }
}

// MARK: Touch Events
extension CarouselView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        startPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let movingPoint = touch.location(in: self)
        let distance = movingPoint - startPoint
        move(distanceX: distance.x)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let endPoint = touch.location(in: self)
        let distance = endPoint - startPoint
        
        if abs(distance.x) < 5 && abs(distance.y) < 5 {
            applyPaging(with: .none)
            mediaPlayViewTapped()
            return
        }
        
        let distanceX = distance.x / frame.width
        if let direction = ScrollDirection.init(rawValue: round(distanceX * 1.3)) {
            applyPaging(with: direction)
        }
    }
}

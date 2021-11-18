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
    
    private var startX: CGFloat = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        bindUI()
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
            $0.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width)
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
            $0.centerX.equalToSuperview().offset(UIScreen.main.bounds.width)
            $0.centerY.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-UIScreen.deviceScreenSize.height * 0.3)
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
            .filter { !$0.0.isEmpty }
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
        previousView.replaceMedia(media: previousItem)
        currentView.replaceMedia(media: currentItem)
        nextView.replaceMedia(media: nextItem)
    }
    
    private func move(distanceX: CGFloat) {
        guard contents.value.count != 1 else {
            return
        }
        previousView.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(distanceX - UIScreen.main.bounds.width)
        }
        currentView.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(distanceX)
        }
        nextView.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(distanceX + UIScreen.main.bounds.width)
        }
    }
    
    private func applyPaging(with scrollDirection: ScrollDirection) {
        guard contents.value.count != 1 else {
            return
        }
        
        switch scrollDirection {
        case .left:
            previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width * 2)
            }
            currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width)
            }
            nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
        case .right:
            previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
            currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.main.bounds.width)
            }
            nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.main.bounds.width * 2)
            }
        case .none:
            previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width)
            }
            currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
            nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.main.bounds.width)
            }
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
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
            case .right:
                let currentIndex = self.currentIndex.value
                let contentsCount = self.contents.value.count
                let nextIndex = (contentsCount + currentIndex - 1) % contentsCount
                
                let tempView = self.nextView
                self.nextView = self.currentView
                self.currentView = self.previousView
                self.previousView = tempView
                
                self.currentIndex.accept(nextIndex)
                
            case .none:
                break
            }
            
            self.previousView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(-UIScreen.main.bounds.width)
            }
            self.currentView.snp.updateConstraints {
                $0.centerX.equalToSuperview()
            }
            self.nextView.snp.updateConstraints {
                $0.centerX.equalToSuperview().offset(UIScreen.main.bounds.width)
            }
        }
    }
}

// MARK: Touch Events
extension CarouselView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        startX = touch.location(in: self).x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let moveX = touch.location(in: self).x
        move(distanceX: moveX - startX)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let destinationX = touch.location(in: self).x
        
        let distanceX = (destinationX - startX) / frame.width
        
        if let direction = ScrollDirection.init(rawValue: round(distanceX)) {
            applyPaging(with: direction)
        }
    }
}

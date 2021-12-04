//
//  HomeViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxRelay
import RxSwift

final class HomeViewModel {
    private let mediaListUseCase = MediaListUseCase()
    private let maximListUseCase = MaximListUseCase(maximListRepository: MaximListRepository())
    private let audioPlayUseCase = AudioPlayUseCase()
    private let playHistoryUseCase = PlayHistoryUseCase()
    private let favoriteUseCase = FavoriteUseCase()
    
    private let disposeBag = DisposeBag()
    private let brightMode = BehaviorRelay<[Media]>(value: [])
    private let darknessMode = BehaviorRelay<[Media]>(value: [])
    
    let mode = BehaviorRelay<MediaMode>(value: .bright)
    let currentModeList = BehaviorRelay<[Media]>(value: [])
    let favoriteSoundList = BehaviorRelay<[Media]>(value: [])
    let recentPlayHistory = BehaviorRelay<[Media]>(value: [])
    
    init() {
        Observable
            .combineLatest(mode, brightMode, darknessMode)
            .subscribe { [weak self] mode, brightModeList, darknessModeList in
                if mode == .bright {
                    self?.currentModeList.accept(brightModeList)
                } else {
                    self?.currentModeList.accept(darknessModeList)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        fetchMediaMyList(mode: .bright)
        fetchMediaMyList(mode: .dark)
        fetchPlayHistory()
        fetchFavoriteMediaList()
    }
    
    func refresh(typeList: [RefreshHomeData]) {
        if typeList.contains(.brightMode) {
            fetchMediaMyList(mode: .bright)
        }
        
        if typeList.contains(.darkMode) {
            fetchMediaMyList(mode: .dark)
        }
        
        if typeList.contains(.playHistory) {
            fetchPlayHistory()
        }
        
        if typeList.contains(.favorite) {
            fetchFavoriteMediaList()
        }
    }
    
    func modeSwitchTouched(media: Media) {
        ApplicationMode.shared.convert()
        audioPlayUseCase.control(media: media, state: false)
            .subscribe(onFailure: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func mediaPlayViewTapped(media: Media) -> Single<Bool> {
        return audioPlayUseCase.control(media: media, autoPlay: true, restart: false)
    }
    
    func receiveNotificationForFocus(media: Media, state: Bool) {
        if state {
            audioPlayUseCase.control(media: media, autoPlay: true, restart: false, isContinue: true)
                .subscribe(onFailure: { error in
                    print(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        } else {
            audioPlayUseCase.control(media: media, state: state)
                .subscribe(onFailure: { error in
                    print(error.localizedDescription)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func mediaPlayViewDownSwiped(media: Media) -> Single<Bool> {
        if currentModeList.value.count == 1 {
            return Single.just(false)
        }
        return mediaListUseCase.removeMediaFromMode(media: media)
    }
    
    func mediaPlayViewAppear(media: Media, autoPlay: Bool = false) -> Bool {
        return audioPlayUseCase.isPlaying(using: media.audioFileName)
    }
    
    private func fetchMediaMyList(mode: MediaMode) {
        mediaListUseCase.fetchMediaMyList(mode: mode)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                switch mode {
                case .bright:
                    self?.brightMode.accept($0)
                case .dark:
                    self?.darknessMode.accept($0)
                }
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchPlayHistory() {
        playHistoryUseCase.fetchPlayHistory()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.recentPlayHistory.accept($0.elements(in: 0..<6))
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchFavoriteMediaList() {
        favoriteUseCase.fetchAll()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.favoriteSoundList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

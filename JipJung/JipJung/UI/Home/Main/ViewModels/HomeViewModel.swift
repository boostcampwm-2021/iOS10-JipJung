//
//  HomeViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift
import RxRelay

protocol HomeViewModelInput {
    func viewDidLoad()
    func refresh(typeList: [RefreshHomeData])
    func modeSwitchTouched()
    func mediaPlayViewTapped() -> Single<Bool>
    func mediaPlayViewDownSwiped(media: Media) -> Single<Bool>
    func mediaPlayViewAppear(media: Media, autoPlay: Bool)
}

protocol HomeViewModelOutput {
    var mode: BehaviorRelay<MediaMode> { get }
    var currentModeList: BehaviorRelay<[Media]> { get }
    var favoriteSoundList: BehaviorRelay<[Media]> { get }
    var recentPlayHistory: BehaviorRelay<[Media]> { get }
}

final class HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    private let mediaListUseCase = MediaListUseCase()
    private let maximListUseCase = MaximListUseCase()
    private let audioPlayUseCase = AudioPlayUseCase()
    private let playHistoryUseCase = PlayHistoryUseCase()
    private let favoriteMediaUseCase = FavoriteMediaUseCase()
    
    private let disposeBag = DisposeBag()
    private let brightMode = BehaviorRelay<[Media]>(value: [])
    private let darknessMode = BehaviorRelay<[Media]>(value: [])
    
    let mode = BehaviorRelay<MediaMode>(value: .bright)
    let currentModeList = BehaviorRelay<[Media]>(value: [])
    let favoriteSoundList = BehaviorRelay<[Media]>(value: [])
    let recentPlayHistory = BehaviorRelay<[Media]>(value: [])
    
    init() {
        Observable
            .combineLatest(mode, brightMode, darknessMode) { ($0, $1, $2) }
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
    
    func modeSwitchTouched() {
        mode.accept(mode.value == .bright ? .dark : .bright)
    }
    
    func mediaPlayViewTapped() -> Single<Bool> {
        return audioPlayUseCase.controlAudio()
    }
    
    func mediaPlayViewDownSwiped(media: Media) -> Single<Bool> {
        if currentModeList.value.count == 1 {
            return Single.just(false)
        }
        return mediaListUseCase.removeMediaFromMode(media: media)
    }
    
    func mediaPlayViewAppear(media: Media, autoPlay: Bool = false) {
        audioPlayUseCase.readyToPlay(media.audioFileName, autoPlay: autoPlay)
            .subscribe(onFailure: { error in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMediaMyList(mode: MediaMode) {
        mediaListUseCase.fetchMediaMyList(mode: mode)
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
            .subscribe { [weak self] in
                self?.recentPlayHistory.accept($0.elements(in: 0..<6))
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchFavoriteMediaList() {
        favoriteMediaUseCase.fetchAll()
            .subscribe { [weak self] in
                self?.favoriteSoundList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

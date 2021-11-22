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
    func viewWillAppear()
    func modeSwitchTouched()
    func mediaPlayViewTapped() -> Single<Bool>
    func mediaCollectionCellLoaded(_ videoFileName: String) -> Single<URL>
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
    private let videoPlayUseCase = VideoPlayUseCase()
    
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
                let modeList = mode == .bright ? brightModeList : darknessModeList
                self?.currentModeList.accept(modeList)
            }
            .disposed(by: disposeBag)
    }
    
    func viewWillAppear() {
        // TODO: UserDefaults에서 현재 mode 정보 가져오기
        
        mediaListUseCase.fetchMediaMyList(mode: .bright)
            .subscribe { [weak self] in
                self?.brightMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        mediaListUseCase.fetchMediaMyList(mode: .darkness)
            .subscribe { [weak self] in
                self?.darknessMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        mediaListUseCase.fetchRecentPlayHistory()
            .subscribe { [weak self] in
                self?.recentPlayHistory.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        mediaListUseCase.fetchFavoriteMediaList()
            .subscribe { [weak self] in
                self?.favoriteSoundList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func modeSwitchTouched() {
        mode.accept(mode.value == .bright ? .darkness : .bright)
    }
    
    func mediaPlayViewTapped() -> Single<Bool> {
        return audioPlayUseCase.controlAudio()
    }
    
    func mediaPlayViewAppear(_ audioFileName: String, autoPlay: Bool) -> Single<Bool> {
        return audioPlayUseCase.readyToPlay(audioFileName, autoPlay: autoPlay)
    }
    
    func mediaCollectionCellLoaded(_ videoFileName: String) -> Single<URL> {
        return videoPlayUseCase.ready(videoFileName)
    }
}

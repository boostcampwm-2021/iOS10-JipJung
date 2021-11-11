//
//  HomeViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel {
    let contentsListUseCase: ContentsListUseCase
    let audioPlayUseCase: AudioPlayUseCase
    
    let bag = DisposeBag()
    let mode = BehaviorRelay<MediaMode>(value: .bright)
    let currentModeList = BehaviorRelay<[Media]>(value: [])
    let brightMode = BehaviorRelay<[Media]>(value: [])
    let darknessMode = BehaviorRelay<[Media]>(value: [])
    let favoriteSoundList = BehaviorRelay<[Media]>(value: [])
    let recentPlayHistory = BehaviorRelay<[Media]>(value: [])
    let isPlaying = BehaviorRelay(value: false)
    
    init(
        contentsListUseCase: ContentsListUseCase,
        audioPlayUseCase: AudioPlayUseCase
    ) {
        self.contentsListUseCase = contentsListUseCase
        self.audioPlayUseCase = audioPlayUseCase
        
        Observable
            .combineLatest(mode, brightMode, darknessMode) { ($0, $1, $2) }
            .subscribe { [weak self] (mode, brightModeList, darknessModeList) in
                self?.currentModeList.accept(mode == .bright ? brightModeList : darknessModeList)
            }
            .disposed(by: bag)
    }
    
    func viewControllerLoaded() {
        contentsListUseCase.fetchMediaMyList(mode: .bright)
            .subscribe { [weak self] in
                self?.brightMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        contentsListUseCase.fetchMediaMyList(mode: .darkness)
            .subscribe { [weak self] in
                self?.darknessMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        contentsListUseCase.fetchRecentPlayHistory()
            .subscribe { [weak self] in
                self?.recentPlayHistory.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        contentsListUseCase.fetchFavoriteMediaList()
            .subscribe { [weak self] in
                self?.favoriteSoundList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
    }
    
    func modeSwitchTouched() {
        mode.accept(mode.value == .bright ? .darkness : .bright)
    }
    
    func mediaPlayButtonTouched(urlString: String) -> Bool {
        isPlaying.accept(!isPlaying.value)
        
        if isPlaying.value {
            do {
                try audioPlayUseCase.ready(urlString: urlString)
                audioPlayUseCase.play()
            } catch {
                print(error.localizedDescription)
                return false
            }
            return true
        } else {
            audioPlayUseCase.pause()
            return false
        }
    }
}

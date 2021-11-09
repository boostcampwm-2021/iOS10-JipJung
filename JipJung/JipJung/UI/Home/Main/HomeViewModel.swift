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
    let soundListUseCase: SoundListUseCase
    
    let bag = DisposeBag()
    let mode = BehaviorRelay<SoundMode>(value: .bright)
    let currentModeList = BehaviorRelay<[String]>(value: [])
    let brightMode = BehaviorRelay<[String]>(value: [])
    let darknessMode = BehaviorRelay<[String]>(value: [])
    let favoriteSoundList = BehaviorRelay<[String]>(value: [])
    let recentPlayHistory = BehaviorRelay<[String]>(value: [])
    let isPlaying = BehaviorRelay(value: false)
    
    init(soundListUseCase: SoundListUseCase) {
        self.soundListUseCase = soundListUseCase
        
        Observable
            .combineLatest(mode, brightMode, darknessMode) { ($0, $1, $2) }
            .subscribe { [weak self] (mode, brightModeList, darknessModeList) in
                self?.currentModeList.accept(mode == .bright ? brightModeList : darknessModeList)
            }
            .disposed(by: bag)
    }
    
    func viewControllerLoaded() {
        soundListUseCase.fetchModeSoundList(mode: .bright)
            .subscribe { [weak self] in
                self?.brightMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        soundListUseCase.fetchModeSoundList(mode: .darkness)
            .subscribe { [weak self] in
                self?.darknessMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        soundListUseCase.fetchFavoriteSoundList()
            .subscribe { [weak self] in
                self?.favoriteSoundList.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        soundListUseCase.fetchRecentPlayHistory()
            .subscribe { [weak self] in
                self?.recentPlayHistory.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
    }
    
    func modeSwitchTouched() {
        mode.accept(mode.value == .bright ? .darkness : .bright)
    }
    
    func mediaPlayButtonTouched() {
        isPlaying.accept(!isPlaying.value)
        
        if isPlaying.value {
            
        } else {
            
        }
    }
}

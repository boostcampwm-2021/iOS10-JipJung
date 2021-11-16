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
    private let mediaListUseCase = MediaListUseCase()
    private let maximListUseCase = MaximListUseCase()
    private let audioPlayUseCase = AudioPlayUseCase()
    private let videoPlayUseCase = VideoPlayUseCase()
    private let bag = DisposeBag()
    
    let mode = BehaviorRelay<MediaMode>(value: .bright)
    let currentModeList = BehaviorRelay<[Media]>(value: [])
    let brightMode = BehaviorRelay<[Media]>(value: [])
    let darknessMode = BehaviorRelay<[Media]>(value: [])
    let favoriteSoundList = BehaviorRelay<[Media]>(value: [])
    let recentPlayHistory = BehaviorRelay<[Media]>(value: [])
    
    init() {
        Observable
            .combineLatest(mode, brightMode, darknessMode) { ($0, $1, $2) }
            .subscribe { [weak self] mode, brightModeList, darknessModeList in
                let modeList = mode == .bright ? brightModeList : darknessModeList
                if let modeListValue = self?.makeInfinityCollectionDataSource(dataSource: modeList) {
                    self?.currentModeList.accept(modeListValue)
                }
            }
            .disposed(by: bag)
    }
    
    func viewControllerLoaded() {
        // TODO: UserDefaults에서 현재 mode 정보 가져오기
        
        mediaListUseCase.fetchMediaMyList(mode: .bright)
            .subscribe { [weak self] in
                self?.brightMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        mediaListUseCase.fetchMediaMyList(mode: .darkness)
            .subscribe { [weak self] in
                self?.darknessMode.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        mediaListUseCase.fetchRecentPlayHistory()
            .subscribe { [weak self] in
                self?.recentPlayHistory.accept($0)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        mediaListUseCase.fetchFavoriteMediaList()
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
    
    func mediaPlayButtonTouched(_ audioFileName: String) -> Single<Bool> {
        return audioPlayUseCase.controlAudioPlay(audioFileName)
    }
    
    func mediaCollectionCellLoaded(_ videoFileName: String) -> Single<URL> {
        return videoPlayUseCase.ready(videoFileName)
    }
    
    private func makeInfinityCollectionDataSource(dataSource: [Media]) -> [Media] {
        guard let first = dataSource.first,
              let last = dataSource.last,
              first != last
        else {
            return dataSource
        }
        
        var newDataSource = dataSource
        newDataSource.insert(last, at: 0)
        newDataSource.append(first)
        return newDataSource
    }
}

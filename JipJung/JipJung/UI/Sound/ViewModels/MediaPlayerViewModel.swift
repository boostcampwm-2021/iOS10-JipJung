//
//  MediaPlayerViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import AVFoundation
import Foundation

import RxRelay
import RxSwift

enum FileStatus {
    case isNotDownloaded
    case downloaded
    case downloadFailed
}

final class MediaPlayerViewModel {
    let musicFileStatus = BehaviorRelay<FileStatus>(value: FileStatus.isNotDownloaded)
    let isMusicPlaying = BehaviorRelay<Bool>(value: false)
    let isFavorite = BehaviorRelay<Bool>(value: false)
    let isInMusicList = BehaviorRelay<Bool>(value: false)
    
    let media: Media
    
    let title: String
    let explanation: String
    let maxim: String
    let speaker: String
    let color: String
    let tag: [String]
    var videoPlayerItem: AVPlayerItem?
    private let id: String
    private let mode: Int
    private let audioFileName: String
    private let videoFileName: String
    
    private let audioPlayUseCase = AudioPlayUseCase()
    private let fetchMediaURLUseCase = FetchMediaURLUseCase()
    private let favoriteMediaUseCase = FavoriteUseCase()
    private let mediaListUseCase = MediaListUseCase()
    private let disposeBag = DisposeBag()
    
    init(media: Media) {
        self.media = media
        id = media.id
        mode = media.mode
        title = media.name
        explanation = media.explanation
        maxim = media.maxim
        speaker = media.speaker
        color = media.color
        tag = media.tag.components(separatedBy: "/")
        audioFileName = media.audioFileName
        videoFileName = media.videoFileName
        configureVideoPlayerItem()
        configureIsFavorite()
        configureIsInMusicList()
    }
    
    private func configureVideoPlayerItem() {
        fetchMediaURLUseCase.getMediaURL(fileName: videoFileName, type: .video)
            .subscribe { [weak self] videoFileURL in
                self?.videoPlayerItem = AVPlayerItem(url: videoFileURL)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureIsFavorite() {
        favoriteMediaUseCase.read(id: id)
            .subscribe { [weak self] in
                guard $0.count > 0 else { return }
                self?.isFavorite.accept(true)
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureIsInMusicList() {
        let mediaMode = mode == 0 ? MediaMode.bright : MediaMode.dark
        mediaListUseCase.fetchMediaMyList(mode: mediaMode)
            .subscribe { [weak self] mediaList in
                guard let self = self else { return }
                
                if mediaList.contains(self.media) {
                    self.isInMusicList.accept(true)
                }
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }

    func playMusic() {
        audioPlayUseCase.control(audioFileName: media.audioFileName, autoPlay: true)
            .subscribe { [weak self] in
                self?.isMusicPlaying.accept($0)
                if $0 {
                    self?.musicFileStatus.accept(FileStatus.downloaded)
                }
            } onFailure: { [weak self] in
                self?.musicFileStatus.accept(.downloadFailed)
                print($0.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func pauseMusic() {
        audioPlayUseCase.control(audioFileName: media.audioFileName, state: false)
            .subscribe { [weak self] in
                self?.isMusicPlaying.accept($0)
            } onFailure: { [weak self] in
                self?.musicFileStatus.accept(.downloadFailed)
                print($0.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func checkMusicDownloaded() {
        fetchMediaURLUseCase.getMediaURLFromLocal(fileName: audioFileName)
            .subscribe { [weak self] _ in
                self?.musicFileStatus.accept(FileStatus.downloaded)
                self?.checkMusicPlaying()
            } onFailure: { [weak self] _ in
                self?.musicFileStatus.accept(FileStatus.isNotDownloaded)
            }
            .disposed(by: disposeBag)
    }
    
    func checkMusicPlaying() {
        let isPlaying = audioPlayUseCase.isPlaying(using: audioFileName)
        isMusicPlaying.accept(isPlaying)
    }
    
    func toggleFavoriteState() {
        switch isFavorite.value {
        case false:
            favoriteMediaUseCase.save(id: id, date: Date())
                .subscribe { [weak self] in
                    guard $0 == true else { return }
                    self?.isFavorite.accept(true)
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        case true:
            favoriteMediaUseCase.delete(id: id)
                .subscribe { [weak self] in
                    guard $0 == true else { return }
                    self?.isFavorite.accept(false)
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: disposeBag)
        }
    }
    
    func checkMediaMode() {
        ApplicationMode.shared.mode.accept(mode == 0 ? .bright : .dark)
    }
    
    func saveMediaFromMode() {
        mediaListUseCase.saveMediaFromMode(id: id, mode: mode)
            .subscribe { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: [
                        "RefreshType": [
                            self.mode == 0 ? RefreshHomeData.brightMode : RefreshHomeData.darkMode
                        ]
                    ]
                )
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func removeMediaFromMode() {
        mediaListUseCase.removeMediaFromMode(id: id, mode: mode)
            .subscribe { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: [
                        "RefreshType": [
                            self.mode == 0 ? RefreshHomeData.brightMode : RefreshHomeData.darkMode
                        ]
                    ]
                )
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

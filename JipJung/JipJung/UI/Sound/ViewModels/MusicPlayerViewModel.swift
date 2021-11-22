//
//  MusicPlayerViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation
import RxSwift
import RxRelay
import AVFoundation

enum FileStatus {
    case isNotDownloaded
    case downloaded
    case downloadFailed
}

protocol MusicPlayerViewModelInput {
    func checkMusicDownloaded()
    func playMusic()
    func pauseMusic()
    func toggleFavoriteState()
}

protocol MusicPlayerViewModelOutput {
    var musicFileStatus: BehaviorRelay<FileStatus> { get }
    var isMusicPlaying: BehaviorRelay<Bool> { get }
    var isFavorite: BehaviorRelay<Bool> { get }
    var title: String { get }
    var explanation: String { get }
    var maxim: String { get }
    var speaker: String { get }
    var color: String { get }
    var tag: [String] { get }
    var videoPlayerItem: AVPlayerItem? { get }
}

final class MusicPlayerViewModel: MusicPlayerViewModelInput, MusicPlayerViewModelOutput {
    let musicFileStatus: BehaviorRelay<FileStatus> = BehaviorRelay<FileStatus>(value: FileStatus.isNotDownloaded)
    let isMusicPlaying: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let isFavorite: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    let title: String
    let explanation: String
    let maxim: String
    let speaker: String
    let color: String
    let tag: [String]
    var videoPlayerItem: AVPlayerItem?
    
    private let id: String
    private let audioFileName: String
    private let videoFileName: String
    private let audioPlayUseCase: AudioPlayUseCase = AudioPlayUseCase()
    private let videoPlayUseCase: VideoPlayUseCase = VideoPlayUseCase()
    private let fetchMediaUrlUseCase: FetchMediaURLUseCase = FetchMediaURLUseCase()
    private let favoriteMediaUseCase: FavoriteMediaUseCase = FavoriteMediaUseCase()
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(media: Media) {
        id = media.id
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
    }
    
    private func configureVideoPlayerItem() {
        guard let videoFileUrl = fetchMediaUrlUseCase.execute(fileName: videoFileName) else { return }
        videoPlayerItem = AVPlayerItem(url: videoFileUrl)
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

    func playMusic() {
        audioPlayUseCase.readyToPlay(audioFileName)
            .subscribe { [weak self] in
                guard $0 == true else { return }
                self?.isMusicPlaying.accept($0)
            } onFailure: { [weak self] in
                self?.musicFileStatus.accept(.downloadFailed)
                print($0.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func pauseMusic() {
        audioPlayUseCase.readyToPlay(audioFileName)
            .subscribe { [weak self] in
                guard $0 == false else { return }
                self?.isMusicPlaying.accept($0)
            } onFailure: { [weak self] in
                self?.musicFileStatus.accept(.downloadFailed)
                print($0.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func checkMusicDownloaded() {
        if let audioFileUrl = fetchMediaUrlUseCase.execute(fileName: audioFileName) {
            musicFileStatus.accept(FileStatus.downloaded)
        } else {
            musicFileStatus.accept(FileStatus.isNotDownloaded)
        }
    }
    
    func checkMusicPlaying() {
        let audioPlayManager = AudioPlayManager.shared
        if let audioFileUrl = fetchMediaUrlUseCase.execute(fileName: audioFileName),
           audioPlayManager.isPlaying(of: audioFileUrl) {
            isMusicPlaying.accept(true)
        }
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
            isFavorite.accept(false)
        }
    }
}

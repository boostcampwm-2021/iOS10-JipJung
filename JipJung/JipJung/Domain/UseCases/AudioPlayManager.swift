//
//  AudioPlayManager.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import AVKit
import Foundation

import RxRelay
import RxSwift

typealias PlayState = AudioPlayManager.PlayState

class AudioPlayManager {
    enum PlayState {
        case manual(Bool)
        case automatics
    }
    
    static let shared = AudioPlayManager()
    private init() {}
    
    private let mediaResourceRepository = MediaResourceRepository()
    private let disposeBag = DisposeBag()
    
    private(set) var audioPlayer: AVAudioPlayer?
    
    func readyToPlay(_ audioFileName: String, autoPlay: Bool) -> Single<Bool> {
        if audioFileName.isEmpty {
            return Single.just(false)
        }
        
        if audioFileName == audioPlayer?.url?.lastPathComponent {
            guard let audioPlayer = audioPlayer else {
                return Single.just(false)
            }
            
            let state = audioPlayer.isPlaying || autoPlay
            
            if state {
                return Single.just(audioPlayer.play())
            }
            return Single.just(false)
        }
        
        return Single<Bool>.create { [weak self] single in
            guard let disposeBag = self?.disposeBag else {
                single(.failure(AudioError.initFailed))
                return Disposables.create()
            }
            
            self?.mediaResourceRepository.getMediaURL(fileName: audioFileName, type: .audio)
                .subscribe { url in
                    self?.audioPlayer = try? AVAudioPlayer(contentsOf: url)
                    self?.audioPlayer?.numberOfLoops = -1
                    self?.audioPlayer?.prepareToPlay()
                    if autoPlay,
                       let result = self?.audioPlayer?.play() {
                        single(.success(result))
                    }
                } onFailure: { error in
                    single(.failure(error))
                }
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func controlAudio(playState: PlayState) -> Single<Bool> {
        guard let audioPlayer = audioPlayer else {
            return Single.error(AudioError.initFailed)
        }
        
        switch playState {
        case .manual(let state):
            if state == audioPlayer.isPlaying {
                return Single.just(audioPlayer.isPlaying)
            }
            fallthrough
        case .automatics:
            if audioPlayer.isPlaying {
                audioPlayer.pause()
                return Single.just(false)
            } else {
                return Single.just(audioPlayer.play())
            }
        }
    }
    
    func isPlaying(using audioFileName: String) -> Bool {
        guard let audioPlayer = audioPlayer,
              let currentAudiofileName = audioPlayer.url?.lastPathComponent
        else {
            return false
        }

        return audioPlayer.isPlaying && (currentAudiofileName == audioFileName)
    }
}

//
//  AudioPlayUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/09.
//

import AVKit
import Foundation

import RxSwift

final class AudioPlayUseCase {
    
    private let audioPlayManager = AudioPlayManager.shared
    
    func readyToPlay(_ audioFileName: String, autoPlay: Bool, restart: Bool = false) -> Single<Bool> {
        return audioPlayManager.readyToPlay(audioFileName, autoPlay: autoPlay, restart: restart)
            .do(onSuccess: { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: ["RefreshType": [RefreshHomeData.playHistory]]
                )
            })
    }
    
    func controlAudio(playState: PlayState = .automatics, restart: Bool = false) -> Single<Bool> {
        return audioPlayManager.controlAudio(playState: playState, restart: restart)
            .do(onSuccess: { _ in
                NotificationCenter.default.post(
                    name: .refreshHome,
                    object: nil,
                    userInfo: ["RefreshType": [RefreshHomeData.playHistory]]
                )
            })
    }
    
    func isPlaying() -> Bool {
        guard let isPlaying = audioPlayManager.audioPlayer?.isPlaying else {
            return false
        }
        return isPlaying
    }
    
    func isPlaying(using audioFileName: String) -> Bool {
        audioPlayManager.isPlaying(using: audioFileName)
    }
}

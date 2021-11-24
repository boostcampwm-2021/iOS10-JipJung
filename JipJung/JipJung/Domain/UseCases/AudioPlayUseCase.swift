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
    }
    
    func controlAudio(playState: PlayState = .automatics, restart: Bool = false) -> Single<Bool> {
        return audioPlayManager.controlAudio(playState: playState, restart: restart)
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

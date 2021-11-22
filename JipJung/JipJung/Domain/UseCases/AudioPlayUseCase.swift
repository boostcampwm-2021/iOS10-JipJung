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
    
    func readyToPlay(_ audioFileName: String, autoPlay: Bool = false) -> Single<Bool> {
        return audioPlayManager.readyToPlay(audioFileName, autoPlay: autoPlay)
    }
    
    func controlAudio(playState: PlayState = .automatics) -> Single<Bool> {
        return audioPlayManager.controlAudio(playState: playState)
    }
}

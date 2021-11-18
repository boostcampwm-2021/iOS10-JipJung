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
    
    func controlAudioPlay(_ audioFileName: String) -> Single<Bool> {
        return audioPlayManager.controlAudioPlay(audioFileName)
    }
}

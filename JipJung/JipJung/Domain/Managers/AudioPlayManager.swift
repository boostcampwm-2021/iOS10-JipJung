//
//  AudioPlayManager.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import AVFoundation
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
    
    func ready(url: URL) throws {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            throw AudioError.badURL
        }
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.prepareToPlay()
    }
    
    func play(audioFileName: String, restart: Bool) throws -> Bool {
        guard let audioPlayer = audioPlayer,
              let fileName = audioPlayer.url?.lastPathComponent
        else {
            throw AudioError.initFailed
        }
        
        if fileName != audioFileName {
            return false
        }

        if restart {
            audioPlayer.currentTime = 0
        }

        return audioPlayer.play()
    }
    
    func pause() throws {
        guard let audioPlayer = audioPlayer else {
            throw AudioError.initFailed
        }
        
        audioPlayer.pause()
    }
    
    func isEqaul(with media: Media) -> Bool {
        guard let audioPlayer = audioPlayer,
              let currentAudiofileName = audioPlayer.url?.lastPathComponent
        else {
            return false
        }
        
        return currentAudiofileName == media.audioFileName
    }
    
    func isEqaul(with audioFileName: String) -> Bool {
        guard let audioPlayer = audioPlayer,
              let currentAudiofileName = audioPlayer.url?.lastPathComponent
        else {
            return false
        }
        
        return currentAudiofileName == audioFileName
    }
    
    func isPlaying() -> Bool {
        guard let audioPlayer = audioPlayer else {
            return false
        }
        
        return audioPlayer.isPlaying
    }
}

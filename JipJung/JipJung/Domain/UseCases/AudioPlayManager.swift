//
//  AudioPlayManager.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import AVKit
import Foundation

import RxSwift

class AudioPlayManager {
    static let shared = AudioPlayManager()
    private init() {}
    
    private let mediaResourceRepository = MediaResourceRepository()
    private let bag = DisposeBag()
    
    private var audioPlayer: AVAudioPlayer?
    
    private func ready(_ audioFileName: String) -> Single<AVAudioPlayer?> {
        if let currentURL = audioPlayer?.url?.lastPathComponent,
           currentURL == audioFileName {
            return Single.just(nil)
        }
        
        return mediaResourceRepository.getMediaURL(fileName: audioFileName, type: .audio)
            .map {
                guard let audioPlayer = try? AVAudioPlayer(contentsOf: $0) else {
                    throw AudioError.badURL
                }
                return audioPlayer
            }
    }
    
    func playPause(_ audioFileName: String) -> Single<Bool> {
        if let currentURL = audioPlayer?.url?.lastPathComponent,
              currentURL == audioFileName {
            audioPlayer?.pause()
            audioPlayer = nil
            return Single.just(false)
        }
        
        return mediaResourceRepository.getMediaURL(fileName: audioFileName, type: .audio)
            .map {
                guard let audioPlayer = try? AVAudioPlayer(contentsOf: $0) else {
                    throw AudioError.badURL
                }
                return audioPlayer
            }
            .map {[weak self] in
                self?.audioPlayer = $0
            }
            .map { [weak self] in
                guard let audioPlayer = self?.audioPlayer else {
                    throw AudioError.initFailed
                }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                return audioPlayer.play()
            }
    }
}

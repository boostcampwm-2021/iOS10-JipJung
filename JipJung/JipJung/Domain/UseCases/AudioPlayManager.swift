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
    private let disposeBag = DisposeBag()
    
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    
    func readyToPlay(_ audioFileName: String, autoPlay: Bool) -> Single<Bool> {
        isPlaying = autoPlay
        
        if audioFileName.isEmpty || audioFileName == audioPlayer?.url?.lastPathComponent {
            audioPlayer?.pause()
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
    
    func controlAudio(state: Bool? = nil) -> Single<Bool> {
        guard let audioPlayer = audioPlayer else {
            return Single.error(AudioError.initFailed)
        }
        
        if let state = state {
            if isPlaying == state {
                return Single.just(isPlaying)
            }
        }
        
        isPlaying.toggle()
        
        if isPlaying {
            return Single.just(audioPlayer.play())
        } else {
            audioPlayer.pause()
            return Single.just(false)
        }
    }
    
    func isPlaying(of audioFileUrl: URL) -> Bool {
        return isPlaying
    }
}

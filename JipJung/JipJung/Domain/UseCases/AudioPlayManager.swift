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
    
    func controlAudioPlay(_ audioFileName: String) -> Single<Bool> {
        if audioFileName.isEmpty || audioFileName == audioPlayer?.url?.lastPathComponent {
            audioPlayer?.pause()
            audioPlayer = nil
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
                    if let result = self?.audioPlayer?.play() {
                        single(.success(result))
                    }
                } onFailure: { error in
                    single(.failure(error))
                }
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func isPlaying(of audioFileUrl: URL) -> Bool {
        return audioPlayer?.url == audioFileUrl
    }
}

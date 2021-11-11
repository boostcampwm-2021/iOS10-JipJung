//
//  AudioPlayUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/09.
//

import AVKit
import Foundation

import RxSwift

// TODO: Protocol을 이용한 의존성 제거

final class AudioPlayUseCase {
    enum AudioError: Error {
        case badURL
    }
    
    private let bag = DisposeBag()
    private var audioFileName = ""
    private(set) var audioPlayer: AVAudioPlayer?
    
    private let mediaResourceRepository: MediaResourceRepositoryProtocol
    
    init(mediaResourceRepository: MediaResourceRepositoryProtocol) {
        self.mediaResourceRepository = mediaResourceRepository
    }
    
    func ready(audioFileName: String) throws {
        if self.audioFileName == audioFileName {
            return
        }
        
        mediaResourceRepository.getMediaURL(fileName: audioFileName, type: .audio)
            .subscribe { [weak self] url in
                guard let player = try? AVAudioPlayer(contentsOf: url) else { return }
                self?.audioFileName = audioFileName
                self?.audioPlayer = player
                self?.audioPlayer?.numberOfLoops = -1
                self?.audioPlayer?.prepareToPlay()
            } onFailure: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
    }
    
    func play() {
        guard audioPlayer != nil else { return }
        audioPlayer?.play()
    }
    
    func pause() {
        guard audioPlayer != nil else { return }
        audioPlayer?.pause()
    }
}

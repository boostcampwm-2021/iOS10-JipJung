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
    private let mediaResourceRepository = MediaResourceRepository()
    private let playHistoryRepository = PlayHistoryRepository()
    private let audioPlayManager = AudioPlayManager.shared
    
    private let disposeBag = DisposeBag()
    
    func control(audioFileName: String, autoPlay: Bool = false, restart: Bool = false) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(AudioError.initFailed))
                return Disposables.create()
            }
            
            do {
                if self.audioPlayManager.isEqaul(with: audioFileName) {
                    if self.audioPlayManager.isPlaying() {
                        let result = try self.pause()
                        single(.success(result))
                    } else {
                        let result = try self.play(audioFileName: audioFileName, restart: restart)
                        single(.success(result))
                    }
                } else {
                    self.mediaResourceRepository.getMediaURL(fileName: audioFileName, type: .audio)
                        .observe(on: MainScheduler.asyncInstance)
                        .map { [weak self] in
                            try self?.audioPlayManager.ready(url: $0)
                        }
                        .subscribe {
                            if autoPlay {
                                let result = try? self.play(audioFileName: audioFileName, restart: restart)
                                single(.success(result ?? false))
                            } else {
                                single(.success(true))
                            }
                        } onFailure: { error in
                            single(.failure(error))
                        }
                        .disposed(by: self.disposeBag)
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    func control(audioFileName: String, state: Bool, restart: Bool = false) -> Single<Bool> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(AudioError.initFailed))
                return Disposables.create()
            }
            do {
                if self.audioPlayManager.isEqaul(with: audioFileName) {
                    if state {
                        let result = try self.play(audioFileName: audioFileName, restart: restart)
                        single(.success(result))
                    } else {
                        let result = try self.pause()
                        single(.success(result))
                    }
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    private func play(audioFileName: String, restart: Bool) throws -> Bool {
        do {
            if try audioPlayManager.play(audioFileName: audioFileName, restart: restart) {
                if let mediaID = audioFileName.components(separatedBy: ".")[safe: 0] {
                    playHistoryRepository.create(mediaID: mediaID)
                        .subscribe(onSuccess: { state in
                            if !state {
                                return
                            }
                            
                            NotificationCenter.default.post(
                                name: .refreshHome,
                                object: nil,
                                userInfo: ["RefreshType": [RefreshHomeData.playHistory]]
                            )
                        })
                        .disposed(by: disposeBag)
                }
                return true
            } else {
                return false
            }
        } catch {
            throw error
        }
    }
    
    private func pause() throws -> Bool {
        do {
            try audioPlayManager.pause()
            return false
        } catch {
            throw error
        }
    }
    
    func isPlaying(using audioFileName: String) -> Bool {
        let isEqaul = audioPlayManager.isEqaul(with: audioFileName)
        let isPlaying = audioPlayManager.isPlaying()
        return isEqaul && isPlaying
    }
}

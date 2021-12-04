//
//  AudioPlayManager.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import AVFoundation
import Foundation
import MediaPlayer

import RxRelay
import RxSwift

typealias PlayState = AudioPlayManager.PlayState

class AudioPlayManager {
    enum PlayState {
        case manual(Bool)
        case automatics
    }
    
    static let shared = AudioPlayManager()
    private init() {
        remoteCommandCenter.playCommand.addTarget { [weak self] _ in
            guard let audioPlayer = self?.audioPlayer else {
                return .noSuchContent
            }
            
            audioPlayer.play()
            
            NotificationCenter.default.post(
                name: .checkCurrentPlay,
                object: nil,
                userInfo: nil
            )
            
            return .success
        }
        
        remoteCommandCenter.pauseCommand.addTarget { [weak self] _ in
            guard let audioPlayer = self?.audioPlayer else {
                return .noSuchContent
            }
            
            audioPlayer.pause()
            
            NotificationCenter.default.post(
                name: .checkCurrentPlay,
                object: nil,
                userInfo: nil
            )
            
            return .success
        }
    }
    
    private let remoteCommandCenter = MPRemoteCommandCenter.shared()
    private let remoteCommandInfoCenter = MPNowPlayingInfoCenter.default()
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
    
    func play(media: Media, restart: Bool) throws -> Bool {
        guard let audioPlayer = audioPlayer,
              let fileName = audioPlayer.url?.lastPathComponent
        else {
            throw AudioError.initFailed
        }
        
        if fileName != media.audioFileName {
            return false
        }

        if restart {
            audioPlayer.currentTime = 0
        }

        configureRemoteCommandInfo(media: media)
        
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
    
    private func configureRemoteCommandInfo(media: Media) {
        var nowPlayingInfo = remoteCommandInfoCenter.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = media.name
        
        if let image = UIImage(named: "app_icon") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(
                boundsSize: image.size,
                requestHandler: { _ in
                    return image
                }
            )
        }
        
        remoteCommandInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
}

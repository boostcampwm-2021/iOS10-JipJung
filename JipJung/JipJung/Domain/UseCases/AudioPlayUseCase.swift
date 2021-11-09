//
//  AudioPlayUseCase.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/09.
//

import AVKit
import Foundation

class AudioPlayUseCase {
    enum AudioError: Error {
        case badURLError
    }
    
    private var url: URL?
    private(set) var audioPlayer: AVAudioPlayer?
    
    func ready(urlString: String) throws {
        guard let url = URL(string: urlString) else { return }
        
        if let currentURL = self.url, currentURL == url {
            return
        }
        
        // Test Code
        
        guard let soundURL = Bundle.main.url(forResource: "testSound", withExtension: "m4a") else {
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            self.url = url
            self.audioPlayer = player
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
        } catch {
            throw AudioError.badURLError
        }
        
//        do {
//            let player = try AVAudioPlayer(contentsOf: url)
//            self.url = url
//            self.audioPlayer = player
//            audioPlayer?.numberOfLoops = -1
//            audioPlayer?.prepareToPlay()
//        } catch {
//            throw AudioError.badURLError
//        }
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

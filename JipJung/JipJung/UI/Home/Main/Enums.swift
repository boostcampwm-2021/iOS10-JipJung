//
//  Enums.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation
import CoreGraphics

enum MediaMode: Int {
    case bright, darkness
}

enum FocusMode: CaseIterable {
    case normal, pomodoro, infinity, breath
    
    enum Normal {
        static let title = "기본"
        static let image = "house"
    }
    enum Pomodoro {
        static let title = "뽀모도로"
        static let image = "house"
    }
    enum Infinity {
        static let title = "무한"
        static let image = "house"
    }
    enum Breath {
        static let title = "심호흡"
        static let image = "house"
    }
    
    static func getValue(from mode: FocusMode) -> (title: String, image: String) {
        switch mode {
        case .normal:
            return (Normal.title, Normal.image)
        case .pomodoro:
            return (Pomodoro.title, Pomodoro.image)
        case .infinity:
            return (Infinity.title, Infinity.image)
        case .breath:
            return (Breath.title, Breath.image)
        }
    }
}

enum FocusViewButtonSize {
    static let startButton = CGSize(width: 115, height: 50)
    static let pauseButton = CGSize(width: 100, height: 50)
    static let continueButton = CGSize(width: 115, height: 50)
    static let exitButton = CGSize(width: 115, height: 50)
}

enum FocusState {
    case ready
    case running
    case paused
}

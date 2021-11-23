//
//  Enums.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import CoreGraphics
import UIKit

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
    
    func getFocusViewController() -> FocusViewController {
        switch self {
        case .normal:
            return FocusViewControllerFactory.makeDefaultTimer()
        case .pomodoro:
            return FocusViewControllerFactory.makePomodoroTimer()
        case .infinity:
            return FocusViewControllerFactory.makeInfinityTimer()
        case .breath:
            return FocusViewControllerFactory.makeBreathTimer()
        }
    }
}

enum HomeMainViewSize {
    static let topViewHeight: CGFloat = 100
    static let bottomViewHeight = UIScreen.deviceScreenSize.height
    static let focusButtonSize = CGSize(width: 60, height: 90)
    static let musicCellSize = CGSize(width: UIScreen.deviceScreenSize.width / 2.5, height: 200)
}

enum FocusViewButtonSize {
    static let startButton = CGSize(width: 115, height: 50)
    static let pauseButton = CGSize(width: 100, height: 50)
    static let continueButton = CGSize(width: 115, height: 50)
    static let exitButton = CGSize(width: 115, height: 50)
}

enum TimerState: Equatable {
    case ready
    case running(isResume: Bool)
    case paused
}

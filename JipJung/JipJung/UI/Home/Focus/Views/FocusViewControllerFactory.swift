//
//  FocusViewControllerFactory.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import Foundation

enum FocusViewControllerFactory {
    static func makeDefaultTimer() -> DefaultFocusViewController {
        return DefaultFocusViewController()
    }
    static func makePomodoroTimer() -> PomodoroFocusViewController {
        return PomodoroFocusViewController()
    }
    static func makeInfinityTimer() -> InfinityFocusViewController {
        return InfinityFocusViewController()
    }
    static func makeBreathTimer() -> BreathFocusViewController {
        return BreathFocusViewController()
    }
}

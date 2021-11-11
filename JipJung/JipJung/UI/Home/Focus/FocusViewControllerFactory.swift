//
//  FocusViewControllerFactory.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import Foundation

enum FocusViewControllerFactory {
    static func makeDefaultTimer() -> DefaultFocusViewController {
        return DefaultFocusViewController(viewModel: DefaultFocusViewModel(generateTimerUseCase: GenerateTimerUseCase()))
    }
    static func makePomodoroTimer() -> PomodoroFocusViewController {
        return PomodoroFocusViewController(viewModel: PomodoroFocusViewModel(generateTimerUseCase: GenerateTimerUseCase()))
    }
    static func makeInfinityTimer() -> InfinityFocusViewController {
        let useCase = GenerateTimerUseCase()
        let viewModel = InfinityFocusViewModel(generateTimerUseCase: useCase)
        return InfinityFocusViewController(viewModel: viewModel)
    }
}

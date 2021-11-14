//
//  FocusViewControllerFactory.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/11.
//

import Foundation

enum FocusViewControllerFactory {
    static func makeDefaultTimer() -> DefaultFocusViewController {
        let viewModel = DefaultFocusViewModel(
            saveFocusTimeUseCase: SaveFocusTimeUseCase(
                focusTimeRepository: FocusTimeRepository()
            )
        )
        return DefaultFocusViewController(viewModel: viewModel)
    }
    static func makePomodoroTimer() -> PomodoroFocusViewController {
        let viewModel = PomodoroFocusViewModel(
            saveFocusTimeUseCase: SaveFocusTimeUseCase(
                focusTimeRepository: FocusTimeRepository()
            )
        )
        return PomodoroFocusViewController(viewModel: viewModel)
    }
    static func makeInfinityTimer() -> InfinityFocusViewController {
        let viewModel = InfinityFocusViewModel(
            saveFocusTimeUseCase: SaveFocusTimeUseCase(
                focusTimeRepository: FocusTimeRepository()
            )
        )
        return InfinityFocusViewController(viewModel: viewModel)
    }
}

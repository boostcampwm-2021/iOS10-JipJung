//
//  DefaultFocusViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation
import RxSwift
import RxRelay

protocol DefaultFocusViewModelInput {
    func startClockTimer()
    func pauseClockTimer()
    func resetClockTimer()
    func startWaveAnimationTimer()
    func setFocusTime(seconds: Int)
}

protocol DefaultFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> { get }
    var waveAnimationTime: BehaviorRelay<Int> { get }
    var focusTimeList: [Int] { get }
}

final class DefaultFocusViewModel: DefaultFocusViewModelInput, DefaultFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var waveAnimationTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var timerState: BehaviorRelay<TimerState> = BehaviorRelay<TimerState>(value: .ready)
    var focusTimeList: [Int] = [1, 5, 8, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180]
    var focusTime: Int = 0
    
    private var runningStateDisposeBag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let generateTimerUseCase: GenerateTimerUseCaseProtocol
    
    init(generateTimerUseCase: GenerateTimerUseCaseProtocol) {
        self.generateTimerUseCase = generateTimerUseCase
        self.focusTime = focusTimeList[0] * 60
    }
    
    func startClockTimer() {
        if timerState.value == .paused {
            timerState.accept(.running(isContinue: true))
        } else if timerState.value == .ready {
            timerState.accept(.running(isContinue: false))
        }
        generateTimerUseCase.execute(seconds: 1)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func pauseClockTimer() {
        timerState.accept(.paused)
        runningStateDisposeBag = DisposeBag()
    }
    
    func resetClockTimer() {
        timerState.accept(.ready)
        clockTime.accept(0)
        runningStateDisposeBag = DisposeBag()
    }
    
    func startWaveAnimationTimer() {
        generateTimerUseCase.execute(milliseconds: 1500)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.waveAnimationTime.accept(self.waveAnimationTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func setFocusTime(seconds: Int) {
        focusTime = seconds
    }
}

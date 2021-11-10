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
}

protocol DefaultFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> { get }
    var waveAnimationTime: BehaviorRelay<Int> { get }
}

final class DefaultFocusViewModel: DefaultFocusViewModelInput, DefaultFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var waveAnimationTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    
    private var runningStateDisposeBag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let generateTimerUseCase: GenerateTimerUseCaseProtocol
    
    init(generateTimerUseCase: GenerateTimerUseCaseProtocol) {
        self.generateTimerUseCase = generateTimerUseCase
    }
    
    func startClockTimer() {
        generateTimerUseCase.execute(seconds: 1)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func pauseClockTimer() {
        runningStateDisposeBag = DisposeBag()
    }
    
    func resetClockTimer() {
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
}

//
//  InfinityFocusViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/09.
//

import Foundation
import RxSwift
import RxRelay

protocol InfinityFocusViewModelInput {
    func startClockTimer()
    func pauseClockTimer()
    func resetClockTimer()
    func startRotateAnimationTimer()
    func startWaveAnimationTimer()
    func saveFocusRecord()
}

protocol InfinityFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> { get }
    var rotateAnimationTime: BehaviorRelay<Int> { get }
    var waveAnimationTime: BehaviorRelay<Int> { get }
    var isFocusRecordSaved: BehaviorRelay<Bool> { get }
}

final class InfinityFocusViewModel: InfinityFocusViewModelInput, InfinityFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var rotateAnimationTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var waveAnimationTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var isFocusRecordSaved: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var runningStateDisposeBag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let generateTimerUseCase: GenerateTimerUseCaseProtocol
    private let saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol
    
    init(generateTimerUseCase: GenerateTimerUseCaseProtocol,
         saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol) {
        self.generateTimerUseCase = generateTimerUseCase
        self.saveFocusTimeUseCase = saveFocusTimeUseCase
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
    
    func startRotateAnimationTimer() {
        generateTimerUseCase.execute(milliseconds: 100)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.rotateAnimationTime.accept(self.rotateAnimationTime.value + 1)
            }
            .disposed(by: disposeBag)
    }
    
    func startWaveAnimationTimer() {
        generateTimerUseCase.execute(milliseconds: 1500)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.waveAnimationTime.accept(self.waveAnimationTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func saveFocusRecord() {
        saveFocusTimeUseCase.execute(seconds: clockTime.value)
            .subscribe { [weak self] in
                self?.isFocusRecordSaved.accept($0)
            } onFailure: { [weak self] _ in
                self?.isFocusRecordSaved.accept(false)
            }
            .disposed(by: disposeBag)
    }
}

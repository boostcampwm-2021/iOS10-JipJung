//
//  BreathViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol BreathFocusViewModelInput {
    func changeState(to: BreathFocusState)
    func startClockTimer()
    func resetClockTimer()
    func setFocusTime(seconds: Int)
    func saveFocusRecord()
}

enum BreathFocusState {
    case running
    case stop
}

protocol BreathFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> { get }
    var isFocusRecordSaved: BehaviorRelay<Bool> { get }
    var focusState: BehaviorRelay<BreathFocusState> { get }
}

final class BreathFocusViewModel: BreathFocusViewModelInput, BreathFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: -1)
    var isFocusRecordSaved: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var focusState: BehaviorRelay<BreathFocusState> = BehaviorRelay<BreathFocusState>(value: .stop)
    let focusTimeList: [Int] = Array<Int>(1...15)
    var focusTime: Int = 7
    var timerState: BehaviorRelay<TimerState> = BehaviorRelay<TimerState>(value: .ready)
    
    private var runningStateDisposeBag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol
    private let audioPlayUseCase = AudioPlayUseCase()
    
    init(saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol) {
        self.saveFocusTimeUseCase = saveFocusTimeUseCase
    }
    
    func changeState(to state: BreathFocusState) {
        self.focusState.accept(state)
    }
    
    func startClockTimer() {
        audioPlayUseCase.readyToPlay("breath.WAV", autoPlay: true)
            .subscribe {
            [weak self] in
            switch $0 {
            case .failure(let error):
                print(#function, #line, error)
            case .success(let flag):
                print(#function, #line, flag)
            }
        }.disposed(by: disposeBag)
        
        clockTime.accept(0)
         Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }

    func resetClockTimer() {
        audioPlayUseCase.controlAudio(playState: .manual(false))
        clockTime.accept(-1)
        runningStateDisposeBag = DisposeBag()
    }

    // 숨쉬기 횟수 설정
    func setFocusTime(seconds: Int) {
        focusTime = seconds
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

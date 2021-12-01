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
    func changeTimerState(to timerState: TimerState)
    func startClockTimer()
    func pauseClockTimer()
    func resetClockTimer()
    func saveFocusRecord()
    func alertNotification()
}

protocol InfinityFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> { get }
    var isFocusRecordSaved: BehaviorRelay<Bool> { get }
}

final class InfinityFocusViewModel: InfinityFocusViewModelInput, InfinityFocusViewModelOutput {
    var clockTime: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var isFocusRecordSaved: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var timerState: BehaviorRelay<TimerState> = BehaviorRelay<TimerState>(value: .ready)
    
    private var runningStateDisposeBag: DisposeBag = DisposeBag()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol
    private let audioPlayUseCase = AudioPlayUseCase()
    
    init(saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol) {
        self.saveFocusTimeUseCase = saveFocusTimeUseCase
    }
    
    func changeTimerState(to timerState: TimerState) {
        self.timerState.accept(timerState)
    }
    
    func startClockTimer() {
        audioPlayUseCase.controlAudio(playState: .manual(true))
        Observable<Int>.interval(RxTimeInterval.seconds(1),
                                 scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func pauseClockTimer() {
        audioPlayUseCase.controlAudio(playState: .manual(false))
        runningStateDisposeBag = DisposeBag()
    }
    
    func resetClockTimer() {
        audioPlayUseCase.controlAudio(playState: .manual(false))
        clockTime.accept(0)
        runningStateDisposeBag = DisposeBag()
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
    
    func alertNotification() {
        let clockTime = clockTime.value
        let happyEmojis = ["☺️", "😘", "😍", "🥳", "🤩"]
        let minuteString = clockTime / 60 == 0 ? "" : "\(clockTime / 60)분 "
        let secondString = clockTime % 60 == 0 ? "" : "\(clockTime % 60)초 "
        let message = minuteString + secondString + "집중하셨어요!" + (happyEmojis.randomElement() ?? "")
        PushNotificationMananger.shared.presentFocusStopNotification(title: .focusFinish,
                                                                     body: message)
        FeedbackGenerator.shared.impactOccurred()
    }
}

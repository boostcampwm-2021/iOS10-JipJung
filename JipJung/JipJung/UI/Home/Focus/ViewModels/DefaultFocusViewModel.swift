//
//  DefaultFocusViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultFocusViewModel {
    var clockTime = BehaviorRelay<Int>(value: 0)
    var isFocusRecordSaved = BehaviorRelay<Bool>(value: false)
    var timerState = BehaviorRelay<TimerState>(value: .ready)
    let focusTimeList = [1, 5, 8, 10, 15, 20, 25, 30, 35,
                         40, 45, 50, 55, 60, 70, 80, 90,
                         100, 110, 120, 130, 140, 150, 160, 170, 180]
    var focusTime: Int = 60
    
    private var runningStateDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    private let saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol
    private let audioPlayUseCase = AudioPlayUseCase()
    
    init(saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol) {
        self.saveFocusTimeUseCase = saveFocusTimeUseCase
    }
    
    func changeTimerState(to timerState: TimerState) {
        self.timerState.accept(timerState)
    }
    
    func startClockTimer() {
        NotificationCenter.default.post(
            name: .controlForFocus,
            object: nil,
            userInfo: [
                "PlayState": true
            ]
        )
        
        Observable<Int>.interval(RxTimeInterval.seconds(1),
                                 scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func pauseClockTimer() {
        NotificationCenter.default.post(
            name: .controlForFocus,
            object: nil,
            userInfo: [
                "PlayState": false
            ]
        )
        
        runningStateDisposeBag = DisposeBag()
    }
    
    func resetClockTimer() {
        NotificationCenter.default.post(
            name: .controlForFocus,
            object: nil,
            userInfo: [
                "PlayState": false
            ]
        )
        
        clockTime.accept(0)
        runningStateDisposeBag = DisposeBag()
    }
    
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
    
    func alertNotification() {
        let clockTime = clockTime.value
        let sadEmojis = ["🥶", "😣", "😞", "😟", "😕"]
        let happyEmojis = ["☺️", "😘", "😍", "🥳", "🤩"]
        let minuteString = clockTime / 60 == 0 ? "" : "\(clockTime / 60)분 "
        let secondString = clockTime % 60 == 0 ? "" : "\(clockTime % 60)초 "
        let message = focusTime - clockTime > 0
        ? "완료시간 전에 종료되었어요." + (sadEmojis.randomElement() ?? "")
        : minuteString + secondString + "집중하셨어요!" + (happyEmojis.randomElement() ?? "")
        PushNotificationMananger.shared.presentFocusStopNotification(
            title: .focusFinish,
            body: message
        )
        
        FeedbackGenerator.shared.impactOccurred()
    }
}

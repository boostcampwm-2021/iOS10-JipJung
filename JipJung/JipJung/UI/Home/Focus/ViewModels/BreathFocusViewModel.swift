//
//  BreathViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/15.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

enum BreathFocusState {
    case running
    case stop
}

final class BreathFocusViewModel {
    var clockTime = BehaviorRelay<Int>(value: -1)
    var isFocusRecordSaved = BehaviorRelay<Bool>(value: false)
    var focusState = BehaviorRelay<BreathFocusState>(value: .stop)
    let focusTimeList = [Int](1...15)
    var focusTime = 7
    var timerState = BehaviorRelay<TimerState>(value: .ready)
    
    private var runningStateDisposeBag = DisposeBag()
    private let disposeBag = DisposeBag()
    
    private let saveFocusTimeUseCase = SaveFocusTimeUseCase()
    private let audioPlayUseCase = AudioPlayUseCase()
    
    func changeState(to state: BreathFocusState) {
        self.focusState.accept(state)
    }
    
    func startClockTimer() {
        audioPlayUseCase.control(audioFileName: BreathMode.audioName, autoPlay: true, restart: true)
            .subscribe(onFailure: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
        clockTime.accept(0)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
            }
            .disposed(by: runningStateDisposeBag)
    }
    
    func resetClockTimer() {
        audioPlayUseCase.control(audioFileName: BreathMode.audioName, state: false)
            .subscribe(onFailure: { error in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
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
    
    func alertNotification() {
        let clockTime = clockTime.value
        let angryEmpjis = ["😡", "🤬", "🥵", "🥶", "😰"]
        let happyEmojis = ["☺️", "😘", "😍", "🥳", "🤩"]
        let times = clockTime / 7
        let message = times > 0
        ? "\(times)회 호흡 운동하셨습니다." + (happyEmojis.randomElement() ?? "")
        : "\(times)회... 반복했습니다. 집중합시다!" + (angryEmpjis.randomElement() ?? "")
        PushNotificationMananger.shared.presentFocusStopNotification(
            title: .focusFinish,
            body: message
        )
        FeedbackGenerator.shared.impactOccurred()
    }
}

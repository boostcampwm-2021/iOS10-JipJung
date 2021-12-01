//
//  PomodoroFocusViewModel.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

import RxRelay
import RxSwift

enum PomodoroMode {
    case work
    case relax
}

final class PomodoroFocusViewModel {
    var clockTime = BehaviorRelay<Int>(value: 0)
    var isFocusRecordSaved = BehaviorRelay<Bool>(value: false)
    var timerState = BehaviorRelay<TimerState>(value: .ready)
    var mode = BehaviorRelay<PomodoroMode>(value: .work)
    let focusTimeList = [1, 5, 8, 10, 15, 20, 25, 30, 35,
                         40, 45, 50, 55, 60, 70, 80, 90,
                         100, 110, 120, 130, 140, 150, 160, 170, 180]
    lazy var focusTime = timeUnit
    var totalFocusTime = 0
    let timeUnit = 5
    
    private var runningStateDisposeBag = DisposeBag()
    private let disposeBag = DisposeBag()
    
    private let saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol
    
    init(saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol) {
        self.saveFocusTimeUseCase = saveFocusTimeUseCase
    }
    
    func changeTimerState(to timerState: TimerState) {
        self.timerState.accept(timerState)
    }
    
    func startClockTimer() {
        Observable<Int>.interval(RxTimeInterval.seconds(1),
                                 scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.clockTime.accept(self.clockTime.value + 1)
                if self.mode.value == .work {
                    self.totalFocusTime += 1
                }
                print(self.totalFocusTime) //
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
    
    func setFocusTime(value: Int) {
        focusTime = value * timeUnit
    }
    
    func saveFocusRecord() {
        saveFocusTimeUseCase.execute(seconds: totalFocusTime)
            .subscribe { [weak self] in
                print(self?.totalFocusTime) //
                self?.isFocusRecordSaved.accept($0)
            } onFailure: { [weak self] _ in
                self?.isFocusRecordSaved.accept(false)
            }
            .disposed(by: disposeBag) // TODO: disposeBag 2개 쓰는 것 같은데 하나만 써도 되지 않을까요?
    }
    
    func changeMode() {
        switch mode.value {
        case .work:
            mode.accept(.relax)
        case .relax:
            mode.accept(.work)
        }
    }
    
    func changeToWorkMode() {
        mode.accept(.work)
    }
    
    func resetTotalFocusTime() {
        totalFocusTime = 0
    }
    
    func alertNotification() {
        let clockTime = clockTime.value
        let sadEmojis = ["🥶", "😣", "😞", "😟", "😕"]
        let happyEmojis = ["☺️", "😘", "😍", "🥳", "🤩"]
        let relaxEmojis = ["👍", "👏", "🤜", "🙌", "🙏"]
        switch mode.value {
        case .work:
            let minuteString = clockTime / 60 == 0 ? "" : "\(clockTime / 60)분 "
            let secondString = clockTime % 60 == 0 ? "" : "\(clockTime % 60)초 "
            let message = focusTime - clockTime > 0
            ? "완료시간 전에 종료되었어요." + (sadEmojis.randomElement() ?? "")
            : minuteString + secondString + "집중하셨어요!" + (happyEmojis.randomElement() ?? "")
            PushNotificationMananger.shared.presentFocusStopNotification(
                title: .focusFinish,
                body: message
            )
        case .relax:
            let message = "휴식시간이 끝났어요! 다시 집중해볼까요?" + (relaxEmojis.randomElement() ?? "")
            PushNotificationMananger.shared.presentFocusStopNotification(
                title: .relaxFinish,
                body: message
            )
        }
        FeedbackGenerator.shared.impactOccurred()
    }
}

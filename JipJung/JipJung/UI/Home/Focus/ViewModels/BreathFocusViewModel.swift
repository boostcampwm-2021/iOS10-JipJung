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
    func alertNotification()
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
    
    private let breathAudioFileName = "breath.WAV"
    
    init(saveFocusTimeUseCase: SaveFocusTimeUseCaseProtocol) {
        self.saveFocusTimeUseCase = saveFocusTimeUseCase
    }
    
    func changeState(to state: BreathFocusState) {
        self.focusState.accept(state)
    }
    
    func startClockTimer() {
        audioPlayUseCase.control(audioFileName: breathAudioFileName, state: true, restart: true)
            .subscribe {
                switch $0 {
                case .success(let flag):
                    print(#function, #line, flag)
                case .failure(let error):
                    print(#function, #line, error)
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
        audioPlayUseCase.control(audioFileName: breathAudioFileName, state: false)
            .subscribe {
                switch $0 {
                case .success(let flag):
                    print(#function, #line, flag)
                case .failure(let error):
                    print(#function, #line, error)
                }
            }.disposed(by: disposeBag)
        
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

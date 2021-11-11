//
//  TimerUseCase.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/09.
//

import Foundation
import RxSwift

protocol GenerateTimerUseCaseProtocol {
    func execute(seconds interval: Int) -> Observable<Int>
    func execute(milliseconds interval: Int) -> Observable<Int>
}

final class GenerateTimerUseCase: GenerateTimerUseCaseProtocol {
    func execute(seconds interval: Int) -> Observable<Int> {
        return Observable<Int>.interval(RxTimeInterval.seconds(interval),
                                        scheduler: MainScheduler.instance)
    }
    
    func execute(milliseconds interval: Int) -> Observable<Int> {
        return Observable<Int>.interval(RxTimeInterval.milliseconds(interval),
                                        scheduler: MainScheduler.instance)
    }
}

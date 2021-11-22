//
//  ApplicationMode.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/22.
//

import Foundation
import RxRelay

final class ApplicationMode {
    static let shared = ApplicationMode()
    private init() {}
    
    var mode: BehaviorRelay<ApplicationModeType> = BehaviorRelay<ApplicationModeType>(value: .bright)
    
    func convert() {
        switch mode.value {
        case .bright:
            mode.accept(.dark)
        case .dark:
            mode.accept(.bright)
        }
    }
}

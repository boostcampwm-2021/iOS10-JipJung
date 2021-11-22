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
    
    var value: BehaviorRelay<ApplicationModeType> = BehaviorRelay<ApplicationModeType>(value: .bright)
    
    func convert() {
        switch value.value {
        case .bright:
            value.accept(.dark)
        case .dark:
            value.accept(.bright)
        }
    }
}

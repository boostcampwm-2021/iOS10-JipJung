//
//  MaximViewModel.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/15.
//

import Foundation
import RxRelay

protocol MaximViewModelInput {
    func fetchMaxim()
    func changeDate(with: String)
}

protocol MaximViewModelOutput {
    var date: BehaviorRelay<String> { get }
    var monthYear: BehaviorRelay<String> { get }
    var content: BehaviorRelay<String> { get }
    var speaker: BehaviorRelay<String> { get }
}

final class MaximViewModel: MaximViewModelInput, MaximViewModelOutput {
    let date: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let monthYear: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let content: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let speaker: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    let imageURL: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    init() {
//        let maximUseCase = MaximListUseCase
    }

    func fetchMaxim() {
    }
    
    func changeDate(with: String) {
    }
}

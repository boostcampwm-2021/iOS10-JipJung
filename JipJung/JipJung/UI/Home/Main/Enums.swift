//
//  Enums.swift.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/08.
//

import Foundation

enum FocusMode: CaseIterable {
    case normal, ticktock, infinity, breath
    
    enum Normal {
        static let title = "기본"
        static let image = "house"
    }
    enum TickTock {
        static let title = "뽀모도로"
        static let image = "house"
    }
    enum Infinity {
        static let title = "무한"
        static let image = "house"
    }
    enum Breath {
        static let title = "심호흡"
        static let image = "house"
    }
    
    static func getValue(from mode: FocusMode) -> (title: String, image: String) {
        switch mode {
        case .normal:
            return (Normal.title, Normal.image)
        case .ticktock:
            return (TickTock.title, TickTock.image)
        case .infinity:
            return (Infinity.title, Infinity.image)
        case .breath:
            return (Breath.title, Breath.image)
        }
    }
}

//
//  FeedbackGenerator.swift
//  JipJung
//
//  Created by turu on 2021/11/25.
//

import UIKit

final class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    private init() {}
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    
    func impactOccurred() {
        lightGenerator.impactOccurred()
    }
}

//
//  FeedbackGenerator.swift
//  JipJung
//
//  Created by turu on 2021/11/25.
//

import UIKit

class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    private init() {
        lightGenerator = UIImpactFeedbackGenerator(style: .light)
    }
    
    private var lightGenerator: UIImpactFeedbackGenerator?
    
    func impactOccurred() {
        lightGenerator?.impactOccurred()
    }
}

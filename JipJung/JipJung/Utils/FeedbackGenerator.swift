//
//  FeedbackGenerator.swift
//  JipJung
//
//  Created by turu on 2021/11/25.
//

import UIKit

class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    
    private var lightGenerator: UIImpactFeedbackGenerator?
    
    private init() {
        lightGenerator = UIImpactFeedbackGenerator(style: .light)
    }
    
    func impactOccurred() {
        lightGenerator?.impactOccurred()
    }
}

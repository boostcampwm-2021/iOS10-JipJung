//
//  FeedbackGenerator.swift
//  JipJung
//
//  Created by turu on 2021/11/25.
//

import UIKit

class FeedbacakGenerator {
    static let shared = FeedbacakGenerator()
    
    private var heavyGenerator: UIImpactFeedbackGenerator?
    
    private init() {
        heavyGenerator = UIImpactFeedbackGenerator(style: .light)
    }
    
    func impactOccurred() {
        heavyGenerator?.impactOccurred()
    }
}

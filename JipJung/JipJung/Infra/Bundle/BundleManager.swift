//
//  BundleManager.swift
//  JipJung
//
//  Created by turu on 2021/11/14.
//

import Foundation

class BundleManager {
    static let shared = BundleManager()
    
    private init() {}
    
    func findURL(fileNameWithExtension path: String) -> URL? {
        return Bundle.main.url(forResource: path, withExtension: "")
    }
}

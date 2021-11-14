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
        guard let url = Bundle.main.url(forResource: path, withExtension: "")
        else {
            return nil
        }
        
        return url
    }
}

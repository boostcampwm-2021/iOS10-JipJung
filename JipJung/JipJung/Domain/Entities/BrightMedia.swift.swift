//
//  BrightMedia.swift.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation
import RealmSwift

class BrightMedia: Object {
    @Persisted(primaryKey: true) var id: String
    
    private override init() {
        super.init()
    }
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}

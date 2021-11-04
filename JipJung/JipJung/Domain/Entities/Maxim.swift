//
//  Maxim.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation
import RealmSwift

class Maxim: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var day: Date
    @Persisted var thumbnailImageURL: String
    @Persisted var content: String
    
    private override init() {
        super.init()
    }
    
    convenience init(id: String, day: Date, thumbnailImageURL: String, content: String) {
        self.init()
        self.id = id
        self.day = day
        self.thumbnailImageURL = thumbnailImageURL
        self.content = content
    }
}

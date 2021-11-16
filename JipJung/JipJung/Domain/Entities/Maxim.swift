//
//  Maxim.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift

class Maxim: Object, Decodable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var day: Date
    @Persisted var thumbnailImageFileName: String
    @Persisted var content: String
    @Persisted var speaker: String
    
    private override init() {
        super.init()
    }
    
    convenience init(id: String, day: Date, thumbnailImageFileName: String, content: String, speaker: String) {
        self.init()
        self.id = id
        self.day = day
        self.thumbnailImageFileName = thumbnailImageFileName
        self.content = content
        self.speaker = speaker
    }
}

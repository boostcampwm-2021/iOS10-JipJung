//
//  Music.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation
import RealmSwift

class Music: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var mode: Int
    @Persisted var thumbnailImageURL: String
    @Persisted var videoURL: String
    @Persisted var soundURL: String
    
    private override init() {
        super.init()
    }
    
    convenience init(id: String, name: String, mode: Int, thumbnailImageURL: String, videoURL: String, soundURL: String) {
        self.init()
        self.id = id
        self.name = name
        self.mode = mode
        self.thumbnailImageURL = thumbnailImageURL
        self.videoURL = videoURL
        self.soundURL = soundURL
    }
}

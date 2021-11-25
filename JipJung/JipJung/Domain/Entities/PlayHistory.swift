//
//  PlayHistory.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

import RealmSwift

class PlayHistory: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var mediaID: String
    
    private override init() {
        super.init()
    }
    
    convenience init(id: Int, mediaID: String) {
        self.init()
        self.id = id
        self.mediaID = mediaID
    }
}

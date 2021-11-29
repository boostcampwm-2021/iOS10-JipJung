//
//  FavoriteMusic.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift

class FavoriteMedia: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var mediaID: String
    
    private override init() {
        super.init()
    }
    
    convenience init(id: Int = -1, mediaID: String) {
        self.init()
        self.id = id
        self.mediaID = mediaID
    }
    
    func autoIncrease() throws {
        guard let realm = try? Realm() else {
            throw RealmError.initFailed
        }
        
        var idCount = 0
        if let lastHistory = realm.objects(Self.self).last {
            idCount = lastHistory.id + 1
        }
        
        id = idCount
    }
}

//
//  FavoriteMusic.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation
import RealmSwift

class FavoriteMusic: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var addDate: Date
    
    private override init() {
        super.init()
    }
    
    convenience init(id: String, addDate: Date) {
        self.init()
        self.id = id
        self.addDate = addDate
    }
}

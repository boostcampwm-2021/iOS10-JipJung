//
//  FocusRecord.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/10.
//

import Foundation

import RealmSwift

class FocusRecord: Object, Decodable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var focusTime: Int   // unit : second
    @Persisted var year: Int
    @Persisted var month: Int
    @Persisted var day: Int
    @Persisted var hour: Int

    private override init() {
        super.init()
    }

    convenience init(id: String, focusTime: Int, year: Int, month: Int, day: Int, hour: Int) {
        self.init()
        self.id = id
        self.focusTime = focusTime
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
    }
}

class FocusRecordV2: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var focusTime = List<FocusRecordTime>()
    
    private override init() {
        super.init()
    }

    convenience init(id: Date, focusTime: Int, year: Int, month: Int, day: Int, hour: Int) {
        self.init()
        self.id = "\(id)"
    }
}

class FocusRecordTime: Object {
    @Persisted var focusTime: Int
}

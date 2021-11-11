//
//  Media.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift

class Media: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var mode: Int
    @Persisted var thumbnailImageFileName: String
    @Persisted var videoFileName: String
    @Persisted var audioFileName: String
    
    private override init() {
        super.init()
    }
    
    convenience init(
        id: String,
        name: String,
        mode: Int,
        thumbnailImageFileName: String,
        videoFileName: String,
        audioFileName: String
    ) {
        self.init()
        self.id = id
        self.name = name
        self.mode = mode
        self.thumbnailImageFileName = thumbnailImageFileName
        self.videoFileName = videoFileName
        self.audioFileName = audioFileName
    }
}

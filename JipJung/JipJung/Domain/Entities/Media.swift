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
    @Persisted var tag: String
    @Persisted var thumbnailImageFileName: String
    @Persisted var videoFileName: String
    @Persisted var videoFileSize: Float
    @Persisted var audioFileName: String
    @Persisted var audioFileSize: Float
    
    private override init() {
        super.init()
    }
    
    convenience init(
        id: String,
        name: String,
        mode: Int,
        tag: String,
        thumbnailImageFileName: String,
        videoFileName: String,
        videoFileSize: Float,
        audioFileName: String,
        audioFileSize: Float
    ) {
        self.init()
        self.id = id
        self.name = name
        self.mode = mode
        self.tag = tag
        self.thumbnailImageFileName = thumbnailImageFileName
        self.videoFileName = videoFileName
        self.videoFileSize = videoFileSize
        self.audioFileName = audioFileName
        self.audioFileSize = audioFileSize
    }
}

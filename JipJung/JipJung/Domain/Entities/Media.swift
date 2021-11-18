//
//  Media.swift
//  JipJung
//
//  Created by 윤상진 on 2021/11/04.
//

import Foundation

import RealmSwift

class Media: Object, Decodable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var explanation: String
    @Persisted var maxim: String
    @Persisted var speaker: String
    @Persisted var color: String
    @Persisted var mode: Int
    @Persisted var tag: String
    @Persisted var thumbnailImageFileName: String
    @Persisted var videoFileName: String
    @Persisted var audioFileName: String
    
    private override init() {
        super.init()
    }
    
    convenience init(
        id: String,
        name: String,
        explanation: String,
        maxim: String,
        speaker: String,
        color: String,
        mode: Int,
        tag: String,
        thumbnailImageFileName: String,
        videoFileName: String,
        audioFileName: String
    ) {
        self.init()
        self.id = id
        self.name = name
        self.explanation = explanation
        self.maxim = maxim
        self.speaker = speaker
        self.color = color
        self.mode = mode
        self.tag = tag
        self.thumbnailImageFileName = thumbnailImageFileName
        self.videoFileName = videoFileName
        self.audioFileName = audioFileName
    }
}

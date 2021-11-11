//
//  DBStructureForJSON.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

class DBStructureForJSON: Decodable {
    enum CodingKeys: String, CodingKey {
        case allMediaList = "Media"
        case brightModeList = "BrightMedia"
        case darknessModeList = "DarknessMedia"
        case playHistoryList = "PlayHistory"
        case favoriteMediaList = "FavoriteMedia"
    }
    
    var allMediaList: [Media]
    var brightModeList: [BrightMedia]
    var darknessModeList: [DarknessMedia]
    var playHistoryList: [PlayHistory]
    var favoriteMediaList: [FavoriteMedia]
}

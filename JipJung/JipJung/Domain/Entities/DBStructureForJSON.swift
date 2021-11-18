//
//  DBStructureForJSON.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/11.
//

import Foundation

struct DBStructureForJSON: Decodable {
    enum CodingKeys: String, CodingKey {
        case allMediaList = "Media"
        case brightModeList = "BrightMedia"
        case darknessModeList = "DarknessMedia"
        case playHistoryList = "PlayHistory"
        case favoriteMediaList = "FavoriteMedia"
        case maximList = "Maxim"
    }
    
    var allMediaList: [Media]
    var brightModeList: [BrightMedia]
    var darknessModeList: [DarknessMedia]
    var playHistoryList: [PlayHistory]
    var favoriteMediaList: [FavoriteMedia]
    var maximList: [Maxim]
}

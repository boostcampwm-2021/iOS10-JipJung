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
    
    let allMediaList: [Media]
    let brightModeList: [BrightMedia]
    let darknessModeList: [DarknessMedia]
    let playHistoryList: [PlayHistory]
    let favoriteMediaList: [FavoriteMedia]
    let maximList: [Maxim]
}

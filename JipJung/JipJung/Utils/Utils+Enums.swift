//
//  Utils+Enums.swift
//  JipJung
//
//  Created by turu on 2021/11/15.
//

import Foundation

enum ApplicationLaunchError: Error {
    case resourceJsonFileNotFound
}

enum ApplicationModeType: Int {
    case bright, dark
}

enum TabBarItems {
    enum Home {
        static let title = "Home"
        static let image = "music.note.house"
    }
    
    enum Explore {
        static let title = "Explore"
        static let image = "slash.circle"
    }
    
    enum Me {
        static let title = "Me"
        static let image = "person"
    }
}

enum UserDefaultsKeys {
    static let searchHistory = "SearchHistory"
    static let wasLaunchedBefore = "WasLaunchedBefore"
}

enum SoundTag: CaseIterable {
    case all, nature, urban, relax, focus, cafe, lounge, club
    
    var value: String {
        switch self {
        case .all:
            return "All"
        case .nature:
            return "Nature"
        case .urban:
            return "Urban"
        case .relax:
            return "Relax"
        case .focus:
            return "Focus"
        case .cafe:
            return "Cafe"
        case .lounge:
            return "Lounge"
        case .club:
            return "Club"
        }
    }
}

//
//  Common.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/04.
//

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
        static let image = ""
    }
}

enum UserDefaultsKeys {
    static let searchHistory = "SearchHistory"
    static let wasLaunchedBefore = "wasLaunchedBefore"
}

enum Genre {
    static let All = "All"
    static let Melody = "Melody"
    static let Nature = "Nature"
    static let Urban = "Urban"
    static let Relax = "Relax"
    static let Techno = "Techno"
    static let House = "House"
    static let Hiphop = "Hiphop"
    static let Jazz = "Jazz"
    static let Disco = "Disco"
}

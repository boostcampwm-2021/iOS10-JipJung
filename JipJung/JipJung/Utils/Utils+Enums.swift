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
    case bright
    case dark
}

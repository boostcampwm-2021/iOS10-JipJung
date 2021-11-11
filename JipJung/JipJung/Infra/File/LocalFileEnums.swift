//
//  LocalFileEnums.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

enum LocalFileError: Error {
    case notFound
    case copyFailed
    case writeFailed
}

//
//  NetworkEnums.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

enum MediaType: String {
    case audio
    case image
    case video
}

enum RemoteServiceError: Error {
    case transportFailed
    case client
    case server
    case unknown
    case badURL
}

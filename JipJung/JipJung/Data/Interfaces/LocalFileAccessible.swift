//
//  LocalFileAccessible.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

protocol LocalFileAccessible {
    func read(_ fileName: String) -> Data?
    func write(_ data: Data, at fileName: String) -> Bool
    func move(from url: URL, to fileName: String) -> Bool
    func delete(_ fileName: String) -> Bool
}

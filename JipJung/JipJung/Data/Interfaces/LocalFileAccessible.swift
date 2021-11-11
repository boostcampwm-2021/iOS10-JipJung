//
//  LocalFileAccessible.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

protocol LocalFileAccessible {
    func read(_ fileName: String) throws -> Data
    func write(_ data: Data, at fileName: String) throws
    func move(from url: URL, to fileName: String) throws
    func delete(_ fileName: String) throws
}

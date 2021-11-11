//
//  LocalFileAccessible.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/10.
//

import Foundation

protocol LocalFileAccessible {
    func isExsit(_ fileName: String) -> URL?
    func isExsit(_ fileURL: URL) -> URL?
    func read(_ fileName: String) throws -> Data
    func read(_ fileURL: URL) throws -> Data
    func write(_ data: Data, at fileName: String) throws
    func move(from url: URL, to fileName: String) throws -> URL
    func delete(_ fileName: String) throws
}

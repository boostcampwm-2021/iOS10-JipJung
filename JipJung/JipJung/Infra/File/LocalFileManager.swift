//
//  LocalFileManager.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/02.
//

import Foundation

class LocalFileManager: LocalFileAccessible {
    static let shared = LocalFileManager()
    private init() {}
    
    private let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    func read(_ fileName: String) throws -> Data {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            return try Data(contentsOf: fileURL)
        } catch {
            throw LocalFileError.notFoundError
        }
    }
    
    func write(_ data: Data, at fileName: String) throws {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            throw LocalFileError.writeError
        }
    }
    
    func move(from url: URL, to fileName: String) throws {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try FileManager.default.moveItem(at: url, to: fileURL)
        } catch {
            throw LocalFileError.copyError
        }
    }
    
    func delete(_ fileName: String) throws {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw LocalFileError.notFoundError
        }
    }
}

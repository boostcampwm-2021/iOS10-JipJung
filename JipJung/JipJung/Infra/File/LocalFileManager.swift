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
    
    func read(_ fileName: String) -> Data? {
        let fileURL = cachePath.appendingPathComponent(fileName)
        return try? Data(contentsOf: fileURL)
    }
    
    func write(_ data: Data, at fileName: String) -> Bool {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            return false
        }
        return true
    }
    
    func move(from url: URL, to fileName: String) -> Bool {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try FileManager.default.moveItem(at: url, to: fileURL)
        } catch {
            return false
        }
        return true
    }
    
    func delete(_ fileName: String) -> Bool {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            return false
        }
        return true
    }
}

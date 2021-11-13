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
    
    // TODO: [safe: 0] 적용하기
    private let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    func isExsit(_ fileName: String) -> URL? {
        let fileURL = cachePath.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            return nil
        }
    }
    
    func isExsit(_ fileURL: URL) -> URL? {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        } else {
            return nil
        }
    }
    
    func read(_ fileName: String) throws -> Data {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            return try Data(contentsOf: fileURL)
        } catch {
            throw LocalFileError.notFound
        }
    }
    
    func read(_ fileURL: URL) throws -> Data {
        do {
            return try Data(contentsOf: fileURL)
        } catch {
            throw LocalFileError.notFound
        }
    }
    
    func write(_ data: Data, at fileName: String) throws {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            throw LocalFileError.writeFailed
        }
    }
    
    func move(from url: URL, to fileName: String) throws -> URL {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try FileManager.default.moveItem(at: url, to: fileURL)
        } catch {
            throw LocalFileError.copyFailed
        }
        return fileURL
    }
    
    func delete(_ fileName: String) throws {
        let fileURL = cachePath.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw LocalFileError.notFound
        }
    }
}

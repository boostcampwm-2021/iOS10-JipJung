//
//  LocalFileManager.swift
//  JipJung
//
//  Created by Soohyeon Lee on 2021/11/02.
//

import Foundation

protocol LocalFileAccessible {
  func read(_ filePath: String) -> Data?
  func write(_ data: Data, at filePath: String) -> Bool
  func delete(_ filePath: String) -> Bool
}

class LocalFileManager: LocalFileAccessible {
  static let shared = LocalFileManager()
  private init() {}
  
  private let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
  
  func read(_ filePath: String) -> Data? {
    let fileURL = cachePath.appendingPathComponent(filePath)
    return try? Data(contentsOf: fileURL)
  }
  
  func write(_ data: Data, at filePath: String) -> Bool {
    let fileURL = cachePath.appendingPathComponent(filePath)
    do {
      try data.write(to: fileURL)
    } catch {
      return false
    }
    return true
  }
  
  func delete(_ filePath: String) -> Bool {
    let fileURL = cachePath.appendingPathComponent(filePath)
    do {
      try FileManager.default.removeItem(at: fileURL)
    } catch {
      return false
    }
    return true
  }
}